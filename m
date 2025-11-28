Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DCECFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 13:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B536B0006; Fri, 28 Nov 2025 08:07:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC266B0007; Fri, 28 Nov 2025 08:07:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2336B0029; Fri, 28 Nov 2025 08:07:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9196B0006
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:07:12 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0779450A43
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:07:12 +0000 (UTC)
X-FDA: 84160041504.17.7827AD4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id F34684000A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:07:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0SZuUd5;
	spf=pass (imf11.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764335230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyCsOey8Tb1Q5O93zaNxc9kNDhLa6VYXzjywxnyvYKg=;
	b=AOp2ML1mDFsOZw6EKsWF725nwJTjYjcNCjwfBEMXBjib7LDX1/Fjz0wCG0X/mFnSrQ6zrD
	zk3rfRXWL5k0TzjoJyWRZ9YMDvxIrnuYD8x7qYd6SAS2HHAPe2YOLwEcsRZ79veNGOyt/c
	YKFNermqZqDBbFyL5vsOpl79iED5lFU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764335230; a=rsa-sha256;
	cv=none;
	b=B4z+5UDZsPvgXnhCenG6twrqCiP+/hUzgSWE6fONVx998uuK6XBe4L4niJexiVQM+xD8S6
	zZcLTceIwskJmooyA4i59FHUKLabJHuA2GPuwvBhJCZIHDVcCd2fj7MzKHBhUB6Wa8jSY7
	BDDqndQFrOIgwmEaZ9/435SDnockOas=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0SZuUd5;
	spf=pass (imf11.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764335229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WyCsOey8Tb1Q5O93zaNxc9kNDhLa6VYXzjywxnyvYKg=;
	b=A0SZuUd5vLNhQ6djDajC+5cIByV4pKdDaIgG0XtfiMAPqTAfpoxL/dAgRdcwi/SYm4m0WD
	RD+bCGadaI4Q5yID8CKOt+ojc7sdsTRddGwtvBD5oXzvQwB3EmC63wUJSmSIFX2BU+PyTm
	/y8SfJ1iTuzoOSKw7z4hQdslXjICcds=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-184-fSAN69SkOnqKsAn7fqhwuQ-1; Fri,
 28 Nov 2025 08:07:05 -0500
X-MC-Unique: fSAN69SkOnqKsAn7fqhwuQ-1
X-Mimecast-MFC-AGG-ID: fSAN69SkOnqKsAn7fqhwuQ_1764335224
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CD071956071;
	Fri, 28 Nov 2025 13:07:03 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1443A195608E;
	Fri, 28 Nov 2025 13:07:00 +0000 (UTC)
Date: Fri, 28 Nov 2025 14:06:54 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Kurt Fitzner <kurt_cryptsetup@va1der.ca>
cc: Aaron Rainbolt <arraybolt3@gmail.com>, Milan Broz <gmazyland@gmail.com>, 
    linux-mm@kvack.org, cryptsetup@lists.linux.dev, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, adrelanos@whonix.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
In-Reply-To: <804601778974c504d42f4423d335a94d@va1der.ca>
Message-ID: <32c2c4c6-d8c0-297a-b0eb-f06a939d5e44@redhat.com>
References: <20251111231835.1232ad8f@kf-m2g5> <2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com> <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com> <804601778974c504d42f4423d335a94d@va1der.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: F34684000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: yhy8ijjaoqtwjbn5rzzdrp8kh7miibna
X-HE-Tag: 1764335229-897916
X-HE-Meta: U2FsdGVkX1/IMtWMLjDubvuTz4zNNbAuGiaR4M36uA2f6jchOXx35jD7LKrzfvZ7fkwz0ZNb0B7QgaWTfY2Pfr1L9dTx4mEXPTZnDv9IxFUeVkoyYNo2ZUkIUkBnIWs+2Pm9JVvVeiwxdRmh5UWci3V8byagVuFltvLT9kS9BI4DpWMD0Ru/CA5CueJ+uX9C3erawS08+ZjnnJvUSrlWD6CgxIpMQj+3gS7fi0ccFLMSmzKyTAce09WJqVS4GWe03rxpoXdBUUhJIa5LWmJNmt8+s95MaS5vAJzFlPZldOH5kIaqSHFPeC9eTQtPc1cD/8QTZFxgETjjpEwPlQGhI6+e1I4Cd4vd7GrqSdy4FB5NcqVF15F6xLWvXCaIdaxhvCec00hM2vuO5XqWWP2fLZc6QWiXQiJCQpLHW/ycFB4bLMfYRXh6Xjf46FUhI4aZKmXdwkuGeVApS+DX73dDBBKEdekOxc/rMg9VPA881fcTpbUWEHdsZj4Ypg8qPGjsLlHJffCMJBpHpSazXAcm8h8EQDsL+a4jrAd296xwoeakpDqiRdxwGd8qXhHGJg5virWT/L3GrT6fDw2XbK7kfZ+XnKKyNGepcIcycRt0d9kzqebOqndybbbcO5dgEp4H+okR7NO/kbeBcYa3irMHxsGXxI3ECKV2ETKtC5/OEK3fh7qyxm2k3WRkrIVKkUinpn24Dt1EqDfiGZ7/ttYSvlGFc0NFO2CswGsyz3AzlGf09qA6Vzw05fAuYZuaNuePSwBUTNKnflz78LsVouIsvPHwJGxaMT/EUVg0urWo6ieWfkLUW5TIVTTenhaTP0Yyxqp8DWEt7HYLj7sTGULyrUMbdKBunw7gaMGyXFk2Znwp3ejOjbyaXWFojU8RuhlWRmEC+0WW1J03UksMZEPw3vrfh5gVM+6zfewX/pT1IRE/TDDj34BfKC/xjnySH7VEo4s+U4MbrF2WLM7gjST
 EGRyOFSl
 wNGYMUEpXV1b8H2Go93Gs1upmDCgKwZ3P1GBS8aGgBVhRO+mfv2XKQ0g+00EQ3Kb0UlD9uk9U3uCK9kcNJh5GsWszzEI+XehWjYNOuXz75WFNUzbg4F4lMM12TKUI86rtzsyicVDxkSpvqYCMVRcl+e2BppS9SzqzJsj+6pbqqh48v0fmElyYtIvY0JOiFNApXmS/qOgvfPTd2sxWM243BT4SZ01ixrgL2DfzSa/1USXPMgXHJStEsXoMepxMhoKDvzok9lfHXTTD5y456oIgK6TVnl4hW5tD1Dk4/Df6UHm9y06e1ik5D2LZcjfgmD8lCfdg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Thu, 27 Nov 2025, Kurt Fitzner wrote:

> On 2025-11-27 13:54, Mikulas Patocka wrote:
> 
> > Encrypted swap file is not supposed to work.
> 
> Do you have a reference for this?  The concept of encrypted swap files has
> been a valid workflow for a very long time.
> 
> > So, this is what happened to you - the machine runs out of memory, it
> > needs to swap out some pages, dm-crypt encrypts the pages and generates
> > write bios, the write bios are directed to the loop device, the loop
> > device directs them to the filesystem, the filesystem attempts to allocate
> > more memory => deadlock.
> 
> If it's the filesystem trying to allocate memory on writes to a swap file that
> is causing a memory allocation/swap race, then any write to a swap file would
> engender the same result, regardless of encryption. The encryption layer is
> redundant under the failure mode you propose.

No - when you swap to unencrypted file, the kernel bypasses the 
filesystem. It creates a block map of the file at swap activation time and 
when it swaps to the file it uses this block map and it doesn't call any 
filesystem functions.

This bypass doesn't work when you put other block device drivers over the 
file.

> I can confirm I have put kernels up to and including 6.14 under heavy memory
> stress and have never encountered anything that feels like a memory allocation
> race.  All my systems have encrypted swap files.
> 
> I can't speak toward later kernels, or any bugs that may or may not be
> presesnt, but I know of nothing to suggest that encrypted swap files remain
> anything other than an intended feature.
> 
>     Kurt

So, it works by chance, not by design.

Mikulas


