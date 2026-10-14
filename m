Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C15CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8DA6B0088; Wed, 14 Oct 2026 04:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFC96B008C; Wed, 14 Oct 2026 04:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE4A6B0099; Wed, 14 Oct 2026 04:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DFF26B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:16:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DBE58A0485
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:16:24 +0000 (UTC)
X-FDA: 85320524688.11.08BC52F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 44C46C0006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:16:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jk25NULz;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791965783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXk+bgsfV6vorpYN5oSqgTgpORjuife32Grsgb2Gqbg=;
	b=pxhQF7z4MGPzoiccASV1IsqRe7UAsAW8c2nD+hGKGLFQUSDpMc8EA0Elj1OqQwBGJbByIL
	JQLmQDujXpxpHWrlIXoJ/euUx9LgFbZBx5qjpW4KjvUl+4YLWyJ9WW3QJ6lFCRnLx+Ty3e
	rdBIhNhwr7F2YqJIXkHE5oA442ESxhk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jk25NULz;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791965783;
	b=LS2X2H07WYqMXISgIt6Azj0Uhvx7EoD5JDt/PV3sojbCwXujI/sHqZQCNdThdoyq9ejn45
	NW+yyQX9UZEmvRXAqwylF3fqtBjNsVERdE9w60TmR6SWLzoK/NJzprB6ncldnUPnU31M1A
	5ASU91OSpJZzKvEWAnRyDeupyT4m6e4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C374960213;
	Wed, 14 Oct 2026 08:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DBE1F000FF;
	Wed, 14 Oct 2026 08:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965782;
	bh=pXk+bgsfV6vorpYN5oSqgTgpORjuife32Grsgb2Gqbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jk25NULzGFVBz2j4agtrSl8HWyhyVJORSzc5FsfdPnnB8S2UAZXm7EXn1s8z2jKtZ
	 5t2xWosLNq2Q+caqbUQxPJBMFSBVX1EZaOGSnAfmUQaanHzxL6nKlNVFBkGCVdv6TR
	 X7bBOc27Mq52Gz1VDSUkY7ZHlmWIVvjv5ZynWC/rCK/3eriytOQCM71BHwsqEJGHAN
	 5pvzwokjmX4VQHLc7cI7h9uJMSL4KR0Wj1TQFYtX9zyNiU/LnDeW9i/kSjw8zeJT8q
	 tE3QmKnXvleSUsC+OlE2V9jd7MbA69/6TSlR9zfJV+ze1x+eGmx1Qrlk12/GBaAO7S
	 KJ4ZQDtyaLpQw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Kees Cook <kees@kernel.org>
Cc: Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v7 0/2] mm/slab, ipc: kmem_buckets kernel-doc and msg_msg accounting fixes
Date: Wed, 14 Oct 2026 10:15:56 +0200
Message-ID: <179196561882.18524.5893215402239363173.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014052338.nothing.279-kees@kernel.org>
References: <20261014052338.nothing.279-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 44C46C0006
X-Stat-Signature: w6xmrcd5sw5by8zfqgsrpho9ey4987xi
X-HE-Tag: 1791965783-497291
X-HE-Meta: U2FsdGVkX1+84jDKbdwsKgMJYPbR2SAs+4MhcU83wE1l8tw3h8yZ2sPsdgGTTGm4jiiPGkds01sDZdfZiv+IJZT7RLmRw0slDWiNgjJOG97xqPT0PwzMkiMVoL39GYQV7/fPdeSOue6ZxplEDAqj2JGnujv3ilXGVIuCAiTaR7a5cfcMFAfz7AhcvJUBeDvt4X3YZOQWqui2uJqPSmYNJdRYH4Kw6cD5GhHl3mUBGDxP4lxA8liS/1Ivl5xxZd+TgUp4xUJnc/kRgPS9eMq2VsWdbx5FvLoER9u0SdMJ/1btFxgOzpauYKoSaFHq6hAq4w9Rg+pvYSpsvJekDXnTSdxwDlUtyyGFga1qU9OlB+N+cHdzU5WkfrRUnn/Jyh6YSPnh4hDnbmT5xDRxHmRODkDYdQ1d/P9GJP9IyLYQU7mt7qUEx3JX/13XKr+Tn2t8ZRT79ftjrMN8Y7Y8PKxwpnY6QR63a7BoNEPBnKsdkB6U6c8T/w+bdl+Cyg7PcMKxIYZENDCra2i5TYxJU3V2g0JkBSLIgWuMWVjP/F/48nMnxV3oRa6Gwt8EXCX1pcnSwrN8Ab39Qi1k5oPUJiKm4Nj5xbvGEPO7k3So3Z8yuGdee7oS4vgRvtpw2GQMGuNkohhjXSKWY5GcP+IIlzn1MBQ3EprEbT+KtOZVl0t+nCj7wtRoGmvB8oNRwdU/VkBeAKs2XnjssfMqx9foJVI9wmp8LPBHyI+5KyYU0fkc2vw6P13kmcfB+89Tqa0Cr3kmHA3mmnNxu6WvZhQwz1W4hF6kByiaWxDnkG+9UuXUUoRiE+tadZMZq7SZ1rOjsEr4ScCq9XvFS0ebcqeUWzeRNAdhAtw8bGKD+HN2NDsWqpC7K06j1tbpqw3Zyp2myABoBCPLTW2kEypL2NDWUv9nttfAAq/MGOlfWpqj8DntUn69p5oVq0GP2PNH0gZ5WkkINNGt2H6DbA6tTNAuwhJ
 n9rSQThp
 gW2S5uRmMnBoEW1enJbBBaUTNO5FBSNmEXjRGkp3Tk/2224xEWuu1TKU1OOVt3hL0UVDptSD5fF2hKo2WwOnxq/P5HiO5CxPWmYRQFTh9C8gul6G80k2/4S1EAebC8/DTXrwEJyDPWZcGxOq4Paw1bXkYbMyAeob07xDmIFrPUV6SiII4sWFaz2K8umgZd21hoSfnDrzCuPAwaGrIQoIOSNj3vpIQSxsVjg5ZCJ+CWcuTaCYlRJvlraS+nAP5uEHQkAOqc9gEaWw9OTJebr0yIMPKheh2IySPUzebtk6hbY4Jf+J1FAEQMecMz9bjaOcVFPaZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 13 Oct 2026 22:23:41 -0700, Kees Cook wrote:
> As Vlastimil suggested[1], these are the first two patches of v6, split
> out for 7.4. The rest of the skb buckets series will come back for 7.5.
> 
> 2/2 now keeps SLAB_ACCOUNT on the msg_msg bucket caches and allocates
> with GFP_KERNEL_ACCOUNT as well, so a msg_msg is charged with
> CONFIG_SLAB_BUCKETS either way.
> 
> [...]

Applied to mm/slab.git slab/for-7.4/misc, thanks!

[1/2] mm/slab: Mark the kmem_buckets_create() context as a Context: section
      commit: 655668f0caf32a42fef10aaf31137e52f46a0260
[2/2] ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again
      commit: 49c0b3dedf7c8c64e432e63dd7b24f00909916d8

Best regards,
-- 
Vlastimil Babka (SUSE) <vbabka@kernel.org>

