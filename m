Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F0AC55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 22:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7947A6B007B; Sat,  1 Aug 2026 18:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71DC06B0088; Sat,  1 Aug 2026 18:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2566B008A; Sat,  1 Aug 2026 18:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30E496B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 18:13:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0C4D1203AC
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 22:13:39 +0000 (UTC)
X-FDA: 85054103358.23.0C9D6AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 13ECB40008
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 22:13:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KHQ48hiK;
	spf=pass (imf12.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785622418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJlf7pM8cQ9k6pN6Z+iBJo1RCv8LUiKgdv4RzZxWTG4=;
	b=8SEeoVXjayV/brX+HkQbT8D+qBd1Lw/VDXcRgvQX6e+7I4XEOtLxZQa3CROcp4XER8DtTz
	cwGDQImGBox4hlz488tai4inlvAzVrYAHf1Yhkd2lM2YJBLafEFEtm+o9q1fgi9juiXhHQ
	qN9ST+Mp1k1MduWNH/XeB1fvKUnr9DE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785622418;
	b=MzPYeAgmGvIBJ3gbGuRuFpxlSx2aA7w5KsiVcsm7d+XvKfV6pmc0KgizYXeii4b3qtXJ/0
	y9bFNco3/K0uZlODs+2rf3TRKtZXVeIDgohhrNSSGWl8Op16UA+CarGxFO8FcX4JuyzzUm
	8c/FduRLoWvJGjZnaoY2M76i9VdX1Rw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KHQ48hiK;
	spf=pass (imf12.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB0FF40ACF;
	Sat,  1 Aug 2026 22:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9911F00AC4;
	Sat,  1 Aug 2026 22:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785622416;
	bh=bJlf7pM8cQ9k6pN6Z+iBJo1RCv8LUiKgdv4RzZxWTG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHQ48hiKz+BNyDU9fHVDIqIZJBlkiqkPt3/uELYYIKbkaopRQfFBYqWNa+05oNCIZ
	 mQ4Zb8k7kQpZu5WPzZ8uD6pj/F6KDOp5920KZ8TffbSRNfxkntwgW+FQMG0CkOH47+
	 bwLyVViqoXPP789cIg7+UXQXiRv82IFQDAxr9UVFf4yFqDGAnM2h2ehQWTuXxK2IQg
	 lWZN+Ffkbyf4Wcn0smhekHkZKU5ueE7vAGqsymLDY10vekONWsNxbmG1+uOyR4ulQl
	 ARiaix8HMFzOKo2ev3Wyeyp5rRTcyVEAiKrCioYf34fuqxhxjlHn6VgYkguvFOnYTW
	 Nbl3iWOKrgEnA==
From: Sasha Levin <sashal@kernel.org>
To: Danielle Costantino <dcostantino@meta.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [7.1.y 0/3] mm/slab: fix unbounded recursion in free path with memalloc profiling
Date: Sat,  1 Aug 2026 18:13:26 -0400
Message-ID: <20260801154223.stable-0004@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260801122533.319272-1-harry@kernel.org>
References: <20260801122533.319272-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 13ECB40008
X-Stat-Signature: 1ercuwk1kxz9cxgpbrqo6untojzebe9c
X-Rspam-User: 
X-HE-Tag: 1785622417-280239
X-HE-Meta: U2FsdGVkX19HiOO8cJjdA36zuN6IKR0CT1QSmqXMZ+9vjSvZOkuNivauRuivXj735i1/HFXi9YTM+d0Bu6wcijM+1ckdCBwpIL6EfTEdEY4hTHfSJgC+G6uYoEuP/OI2lgYYbpS7liyTjSrKO5zIzeXPXQRSZlGS5RZhDLLS4bSMeiLDODnsavttklesrPp8R9b2hddYab5J3r1OoY31pdHbngw7zT9SRzEUnc16UK5ObZm/TSsbl/ezsuARDNF5FxkCTTFMzXPwdH6cPBTz5/LpZq3DeGa76+ZI4Ywb8h2GS3mnNYb4rKHn4znzbP9g/FdnuO1QpAw3eaTuLEYIkIHxTlNMqtKzfdAsik3Yl2Hyp6mBCEtdS2Fo/wffBkr59Pz4k51iAZjauKjIycmW0uABuIfKK8FBT7E8FJgLyEbuKoFq46oE9i7Vx9kyLbRp3wJaF/4yuq/msNIEH3RUPC4/YpKjsIdEfKfIemzr+AoicT7AeRzH0SSCs0Y3DAx2RvFIfEfRqCDrk7E5gYOtfTIeFvmF6FRR0sOnqkg743bPDkPH/AyVanAtwH3YbY54rUGuu28Fg5p+9HTYAgVcFoM7/Fl88+oftcCWEwSvgBv92026wh0osXSR/yP6YW8jNe7P3/gp2CN80b45EDZY8tsAi7pWcMnU9Y/n06HKghzCF3bovBzJByLxgh7+KU6sguQAuDQGsbCcupC4X1MSiMsnYBKzu0WOSP7O8LPgYcYHps4G4l6EJhPtcl1IWPSQtUqLL0UqEjeORtmIzSLIhQW1NZzrqnhGWYd2qSGgHcivZtR5VwoPz8ztBz6+iiY718ysBx/wZ50gOmsDFE6pG3rc4wsW1niKFesBNYTXC7Awg+pdlB4HFUjbPQYu7UbOteM+Tr2o7YgrhazYqDcCIr6iZ7nolanwvhL8vYjCDQ8w1TCt4Vc9TLfsY26QHxOvlFJfQ1bkSy4GoUk+78V
 L5FWhEPe
 buzT1KOEYoy5nh2o1oHv94+QUWLtuVHlQpiB/GND2k98GJ3DsPcziUvWrHwTF3lf2yF5Tqzj4L/miTR1wguUmCB4JsIL0WKz/CTz6jIdWxdqrRCo0LpSRbdCnmuoTn9YGr+L2OrJS5InQFUd0gE3zXTZh1HRLfHu8Kg2Tt+NfJWodVRXlmY5E79VHfHmCVyF+VgMtWledERSGdJx9x93pjeMxJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 01, 2026 at 12:25:30PM +0000, Harry Yoo wrote:
> This is backport of "mm/slab: fix unbounded recursion in free path with
> memalloc profiling" series [1] for 7.1.
>
> The last patch has a slight functional difference compared to mainline
> due to lack of SLAB_ALLOC_* flags. I described those subtlties in the
> backporting notes in detail.

Queued the series for 7.1, thanks.

-- 
Thanks,
Sasha

