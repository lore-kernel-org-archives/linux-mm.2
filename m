Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40A5BF483D7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F2F6B0005; Mon, 23 Mar 2026 15:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF156B0088; Mon, 23 Mar 2026 15:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914A46B008A; Mon, 23 Mar 2026 15:56:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 831496B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:56:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6946BDC03
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:56:10 +0000 (UTC)
X-FDA: 84578384100.29.58C62A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0AD7640008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:56:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pehxsDKj;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774295769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCZuDu09A2jfbdtIcwpkY9LdjhGr2zAPyWQoaNHPIDc=;
	b=j7JxzgBdiIXz3FTYqaOWQlG0edLNJXZMxKkVptAlGzOLJJEy7feD4D2kW6CMTlxdU8FPNv
	ktXFRMbKo2e2ZJNhDn8JyeiUrrMgK4X8FRmpRCwvxKOrOka2ohS23n6g2/OGVhOScp2POF
	S5LD5vFSCr7oJ3AO1/HxDkatxD6OHh0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774295769; a=rsa-sha256;
	cv=none;
	b=3/T6cB+K2hSaGvs5EUTNvBnlgdkm4k1LWmiOq2r/cR7M/TX639sfklck65DrlBC4emRLIF
	cLISa5Yln+cGuENBOtL+u+s6ncudshiKYPl8GyDI12Q0Q5J+X4u/J1pRVXEWkWhL2vCmuE
	Ynm8YcKnA12RxyKXAh+qB0vf+/sWG+M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pehxsDKj;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C6A2F43F61;
	Mon, 23 Mar 2026 19:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4935CC4CEF7;
	Mon, 23 Mar 2026 19:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774295767;
	bh=kjRbcw71r11JI072zOdiu0k1SMF7kUPjaV24JWXZRJ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pehxsDKjmHi7i6PM5B4VBIDf4A9tt5hZh0zwhUINTslYkFF675Eel4gwCoVacls/5
	 tDXg2HBIQEVu2VXQz1DSs58tpQFa0lt0AsZu7XSfv6OydiYUvRQv6AoLz8sqyuH1Nb
	 7iotP7DcCrsNS2S9Q18XYwAxNcgNHbuChDvxn4bQ=
Date: Mon, 23 Mar 2026 12:56:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: YoungJun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, chrisl@kernel.org, kasong@tencent.com,
 pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
 linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 0/2] mm/swap, PM: hibernate: fix swapoff race and
 optimize swap
Message-Id: <20260323125606.820518227d80a30f7e022fe7@linux-foundation.org>
In-Reply-To: <ab/E5SaSAlAKLCwD@yjaykim-PowerEdge-T330>
References: <20260321103309.439265-1-youngjun.park@lge.com>
	<20260321105921.19388b7acbc0f8d6036e29a7@linux-foundation.org>
	<ab/E5SaSAlAKLCwD@yjaykim-PowerEdge-T330>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 9yw8wm5brjomsgq8swdm34z4g1zj7n74
X-Rspamd-Queue-Id: 0AD7640008
X-Rspam-User: 
X-HE-Tag: 1774295768-296595
X-HE-Meta: U2FsdGVkX1+wKBc2A7xV2Fa7BO5XARbtv1CsfVI1qGW0CRZ6H/IQveRDOxX6T7mXPOq5zJ+OzSEAFUQ1rSvnxqFVm4zPdvIvsWfbDs5E+EXTZG4AWuZhudVkmuLq/qfi4M+uCE4hfkFtLj1fgnSdfjWXq4RzIvhYTExAVAfHgjZBAYsqydfjRAfjQjCoxbhzHg0JQTUXgE3MQBZf9H1YenJtsyYHM0rCUYZw0chqZH64xPc6CTBSas49Fm2/1EvBlSAAQ8FW5g5F/01gk2lXi60KtYsQ/Dj7ZzzDE5v/+PkmHkXaDpQPoci6Il+rfPD1WA62B7whspKWRcRs4woP37W/2GIEEKH+WZaDCzpLynKft+af2lO5rJY+kVuXVIvHyW2IweSG4DKa+xfyRIqnMPkImEA6gj5MH5ZozxcPFX37GNolWhAmFU39DYjg1MIyKJQ7xGG3L/UeQa3jqbHWTfRwoXUU08vQCkJveF2bL0VyA5eJn13VstCu/rcd1L8z05Tud0yWAIowaT/LcxnPKhLtNCK7ktIm0s6+ohi/kBrOfgiV9IsVaDr3pkDIktdFYrlqOKqQE27y8k/30+VdLWQ+x+mjK58USWlqjiVYUhiBGP1GNW3mcqu1/RH8ZzHYaQp9TuOCDKy/TB4+LW1hWl0zizc7iRZ7izGKn72zIT2g6w2wvrsYsI8Tu6ul9iaUjuxfX2BF4PDjfl8D9hjC3eayjiYfeXTx345KL4eTj/eX5xuzkFGqwA/8Pc2MzGTxsMZwUcGm2KxeIyeU6TTiFrbkHdsojikZSRYrNwilRYY7HuIqaFE4NAgEcbNAizRP7RuR6Q9QagLIa3BKJ4fCW+y685+jfhCl39ubKwrARQUCpb06f2lO/2N1RaDRmUuUs7mFTXz9AZNCuXbngP01NeKGIKYZuQS3pocCvbicXMOdRbpjzt77O8USLYUdzzPRhawXa+nJ4hNPWaKJX6p
 ENDrJ2Vo
 bSx0O4N98yb8xA1SrzzNHzgAfdIkN9kIl8hXLTBQJIM7wkejAZkp1pNXiszcFBDbA6rNIOrHr5CEZIcRmqNFXwQzoMrJKgJQd3P3HWZlEtwZymj/T6gWgaLVUAODugJcCpX5encK9wrY+41ZlVjFpV97y/F57XS87pL+H/aEgH3VGWCmy/DBrk0dqcO3BEZE8Yk2OLWvynyqtyG4IUf7YRkz1ROYEDBzDtv5S2TifK98TXQzqrG7RzeB5B7NBIgcYlnm3puaq3Igbqw8nn8jSzYTjOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 19:31:01 +0900 YoungJun Park <youngjun.park@lge.com> wrote:

> I based this series on v7.0-rc4 per Rafael's request since it
> depends on PM-side changes. I'm not very familiar with how
> cross-subsystem dependencies are typically coordinated -- if
> rebasing onto mm-new is an option, the race goes away and the
> PM-side changes could be picked up separately. Would that be
> a reasonable approach? I'd appreciate any guidance on this.

hm, yes, 2/2 doesn't apply to linux-next.

The easiest approach would be to park this until the next cycle.  How
serious is the bug?

Or Rafael can merge the whole thing, if we can tease some review out of
the swap maintainers (please).

