Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FFD4CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4256B0005; Thu, 14 May 2026 18:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D596B0088; Thu, 14 May 2026 18:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32C416B008A; Thu, 14 May 2026 18:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8336B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:02:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF4DD405D8
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:02:41 +0000 (UTC)
X-FDA: 84767400522.18.4C8805C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25956A000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:02:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MKzNfJl5;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778796160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eHRH2/rgIG1TlXWyNHRw+SYgVvF8OsTmkjAYD8PdGmU=;
	b=JVD/jetOI2aBNzXX8uQUjc2crAS1i2zkBwnMLnqD5DwgCz7Au+HX8KCeTVmxqDbSLWxfBh
	8lnkvNR/qCcgEXQJ1FHGWJYb3v00Jy30oD4l8bSnbS3Rh5I4GBW5xKh/dA27Bq9bdEbdbI
	0j4tsIaHE0E+CRcWmq3UtKKJu0UJNqI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MKzNfJl5;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778796160; a=rsa-sha256;
	cv=none;
	b=Ef2TL2jZqHZWplK72+/3B0qOh6sDX5nWxWSyQs2BKZrwVQS/USqMSYmPo+wjaAObt81sfw
	Nr0qCeGrzFzht42kQVrH+Li+WNzRBllB7D0anV6PrP0eiKDb498YfmenSRIH7CHhf8RmvL
	ItYLrCbUddzZMHR5L3X0lvMZwdMqG20=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7081060132;
	Thu, 14 May 2026 22:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C33C2BCB3;
	Thu, 14 May 2026 22:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778796159;
	bh=2X9ZgN8061Mu8+oMsn/2rf62DJhzRPO1bUbIFZDbC0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MKzNfJl5ZJpP3FvSiTlPKrUZZEDOh4enqVrhs7nN4M3ofCxcaVXlh8RsHd7h7J1m/
	 geav/iV1/DQwnT5QUe1Wif/jIEQWqoVEBClonF8Gybe6czpagJOQO2y+CW6m4fakQw
	 Wm49Vqavhj4zPjYhs3SkryL6fi73tuUnxJ4CX1PVCaTxpkgG59n80mCI58q/+S1dsC
	 9in1aAUGp8oMN5a4PXUSDYRBJeH8HZJ3yTV1S8kJqTYzVnV5DD6dHOFGpGdrJA+p3b
	 CAEZKcDHuBLamir939h5sISQe863yq3gSwg2IvGQXF/T6MWVU4tJW43QwXugouTv80
	 JwkYOD0KxtM2A==
Date: Thu, 14 May 2026 15:02:37 -0700
From: Minchan Kim <minchan@kernel.org>
To: wang wei <a929244872@163.com>
Cc: richardycc@google.com, akpm@linux-foundation.org, axboe@kernel.dk,
	bgeffon@google.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	liumartin@google.com, senozhatsky@chromium.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] Re:[PATCH v3] zram: fix use-after-free in
 zram_writeback_endio
Message-ID: <agZGfRoVRPKW3LEU@google.com>
References: <20260512074918.2606208-1-richardycc@google.com>
 <20260513140218.7425-1-a929244872@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513140218.7425-1-a929244872@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 25956A000A
X-Stat-Signature: 74fwqmydom61azx44extkfizccc46nzj
X-HE-Tag: 1778796159-933809
X-HE-Meta: U2FsdGVkX192RTv7+/qoC7JcsiKobqCYYnfL0STlj11wBaO2lRugIaT/xHvcDowY21bmG1kPGEjDE00KkGAIPBqTEVzEjFiyb369GnAFmrHtd/MuchkPyMpSJvfIkfAhvvnrMkuaGRg26o6Wx6XmlCkPe5NOoL+8TzvPONlc6Kv6N/DhTSNpm9m++XCsV08S7azNmkVvzsqVqNeYcmr2r/854w854OCtIB6FeYoibpMNbLDgpoL8RS0drtcCbpwTKGvW5GH8mwkHNfc2gtRnybkd+skl+bCBd9DrqH0pCm0sj1QD6dJnmrXBx/NTggjE+JmbHazV8fdjvLE+dz+dkm8z9NZK7vCt3iZS9MFpDQ5br3vFp5q51Eu7ztugJCSIFhaxYNMTevHHTqt5PquK8lefAjHhxki8p2kVhqDg3faCnhMOBNC7035JylGanhhFD2bX4dXNVaOex8IRYxw0CtJ9rzFAz/BdWu2UzaI7DThQAoLBn5QO0t+J/VqiSsIxQ5FRx4AbNPrir7rCAFQEDvUfxeKOXZ2JJqP7Bd2otGuxFBlzwDa/jFeizqBjMfVibWUmZ7JG2oqa5/PtdD2Lhbmhi0g8eNzzcI7mhXKrK8KMbmMqGuwEDSUKoS/YVeKyD0z3B0B7Ps91O+vwdRRyQo76gnDFFJL/GC6PZ2/UrHopxpdMk+p/8G/35E0O7HnMMYOQR2OWQ+3HapYIwvJXOoHYON25mnU8M4akRmq4RF5BG0fZFI9V0F2V5gi6UZN8x7Gm9z6ch8Kegb5xKJ4pAhR+leJoQdMufEoL2JDWWv3PACrmles7TBVnxRjPAzkN+5gXcJEPbdOiF5zmcKkiMdYa7b5mQWCvJoEBiPbSDql7NII2fO95QIIT0dVJXPin/p91PZS9gxsKksgdwwG93WiL8AjAVbF+XOHiNZI1gls7GB+SjGYPp/FlRt0Q08qOF51oSsRD+vW0NUlflQV
 p/1Z9hXi
 wh7BGqBkS2ipduug+btDJWYucEWDrD1qcU5uzw7LeE3cGs/CFdWyn+76MZxfDHjsxq9wyNxJlnrunt02NxFXBdDVCGFzKACGDg7Ks6idblcEXiN3rtM5TkfgmNxvGRQ6XrChjqFZEa2FaCoK9t5H0JmrtA9FVHARA12jhFX64qaFPaUOlp4yolYMjFGgTo5ZxI7jBdFx9LWCN22fiFFeSLWW90CwNlbWV3wWgInIbZwCR4oHQ6GizQxhNQTtcdr+L1A5/E1LpqNzJfkMeMxU9LOqYSyErsKq8VJf2LLqdxtPMOR1+9v+G8GNIHQSltTb+sidEvMvdVVVk1vhk/LmglunzXaEFBgJyYX6X48iC4WprATec3QVlnG3zay4N7Gab1dV5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 10:02:18PM +0800, wang wei wrote:
> >@@ -847,7 +849,7 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
> > 		release_wb_req(req);
> > 	}
> >
> >-	kfree(wb_ctl);
> >+	kfree_rcu(wb_ctl, rcu);
> > }
> 
> Do we need to add a 'rcu_assign_pointer(wb_ctl, NULL);' before 'kfree_rcu(wb_ctl, rcu)'?
> 
> Signed-off-by: wang wei <a929244872@163.com>

Why do we need it?

My understanding is rcu_assign_pointer() is typically used to publish NULL to
a shared pointer variable so that future RCU readers (using rcu_dereference)
won't access the object before kfree_rcu().

However, in our case, wb_ctl is not stored in any shared pointer variable.
It is a local variable in writeback_store() and RCU readers (zram_writeback_endio)
do not look up wb_ctl from a shared pointer. They obtain it directly from
bio->bi_private of the specific bio they are completing.

Please let me know if I missed anything.

