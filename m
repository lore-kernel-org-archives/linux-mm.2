Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 402DCC624CF
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10CBA6B0088; Mon, 31 Aug 2026 12:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BCF46B008A; Mon, 31 Aug 2026 12:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDEE6B008C; Mon, 31 Aug 2026 12:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1B256B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:18:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 500F980125
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:18:05 +0000 (UTC)
X-FDA: 85162071330.02.2F46BD2
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 746CC180005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:18:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="qu/aDKcu";
	spf=pass (imf24.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788193083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wASPUEGd3KOv6Fdubi246q8cZj4P8D3ytyUATn9DWg=;
	b=vYEGiMSJT8gZ/dFaY98bP7Nf1hoGEcmS0jxBrA/zKwJy5Luhu+46CNOHidM/A+OuKb7TRk
	vbAP6Ap0AQRBqvqxAqQFD3UJZZByoxPEoeIRS7rqp1KTXAbopa3JlKCFx/0atGHKlUJ/Vk
	jde58nkS1pc4ik9/g5ZyhUzZpSCHD58=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788193083;
	b=X48km3TJgqShjrctxzEzPdrwpWPQSs9RLsGyiN2KoRiuVmJFReXsEev0YGa7/jnSH9LrVb
	AsWIpLrOjOEI3wtfEYhmKPp0GdeL2682FcsCryzzgN0owwSkC84OrbSMXQwNbBUfV9SLTd
	jd1o0TdBjJiH1q8BRm9tBV3hgEOCGjs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="qu/aDKcu";
	spf=pass (imf24.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cf452def93so186725ad.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788193082; x=1788797882; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4wASPUEGd3KOv6Fdubi246q8cZj4P8D3ytyUATn9DWg=;
        b=qu/aDKcu1HUTnbk4AWaI+OboAXbg5XmYgLV9PnxA7Ve7ZyZQdZk3p/4dBF4s7alAM+
         X2IsUHJtRW9fRs0jkP+FX8dM7TWAhrnU+WsFemN1FJvWHjFzwoWvk7SLJJbix+Wc3JNK
         dLS9Hxflb5c2TZILqGKaSySYJyy1SddOPWvorW5rHF9OE1qEFGAiHzd1QdSRvn1gXzG9
         p2L/majaqmelklcV3kDXd89szRwKZWzsoxpkJG1IvIpW4zVmxm5hlHWdCvUYldIv32G3
         csCGyGkQH9kEDgvokskKzRvhPUXC3hBMvyr3LMLD5WpdfqmnceAVaV4LfUjg7pUdrERv
         RGTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788193082; x=1788797882;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4wASPUEGd3KOv6Fdubi246q8cZj4P8D3ytyUATn9DWg=;
        b=rp5yXOSbymAf2UKCqOR/u2WCJI1EOzIEnpt3TMv+186lSz8oNtCqEh8FIS236dqBjO
         SfCzNDlQBtRqDXmaLnURfKhinDU8PI8jkIo0vpfEgNFPbQ1E8W1/hsBaWGYERiYeT/+T
         IEay+EHBrvnTXorklD7nC5xHkppJdflmrRya+uMpgqi9Fyc0TNILfGelRqXFAisx1ys6
         5NUPnysL2gVjUJrII8sgjoiV4lF/IQZ5y0IVWt228ou+Clx7+wTZJGMN351kdZXTiOy1
         7WmRwoentJL3DfqP48jGbGa0+qlGfTM1jDsGcJbaF845Jpotgf4UTXga5POxpX6Emyh6
         z/Ig==
X-Forwarded-Encrypted: i=1; AKwUvBxEKDvO7+kNUNze2uB+vbzg0jA4ccsMBp2ukfq8dk281bulnuJ/mS4oUM94pTf0//q/8/RhKrbc6Q==@kvack.org
X-Gm-Message-State: AFuF++mc4f/PPNPjdDvqceXcHHyz0Envivc7bzv6+msYgk4tISl+M+SG
	0F7NSO3aE8YTErl5EvYd7P7AIhD6u+3qzykZeo8qTTGp0my+YZ6sSYrOdV9usQ==
X-Gm-Gg: AYBFou3HwixH1CPpSnzQ92rqh4IzREEuh0OKzLSuQT55HkLhiz/YPBC84ZQHWa03o3g
	8FfAnupwtTNvpEdTcjG7b4TN59zIbhfxBlz5EMYtYmK3v2fhMx2S6IQwAG6eLtxe5O71ZrtOBCi
	69bSFHWZP+tqTLYxS5YvmzqYiIjTA8ARpPQlCegspa9et1kZXpjjowxI5O0Kksv8comyZHOXrvu
	mZE518jnKGYug7HVkx2Sm0Hx5CkS/1ogcf1xwIkbKIBUvwOYDzIMMQ3aNhxRk2+yxLkb9p9eTpN
	8eA3vtYUsNTyrWsyg7EU96s6SbZ0A+KejLUpDAOqZVD3SbsR6yWcdZackLnouxCLfdZGE6cHY8D
	rgpi3Ro97Fz1Tm9y5qdbPLEnPK/pIp48vgkccAgMegXzb2V+60PyUJnL96JocpoyA3oROgdsOKf
	quSzONPaVPg4c8TxheXeNXsC2yxtt8YGcNwNJiFJHZdTg1hWh8BGLIfVRgj0+uJiYF1SrPwT0cq
	n+KTY+l
X-Received: by 2002:a17:90b:47:b0:384:927f:3db9 with SMTP id 98e67ed59e1d1-398da5981f2mr7582035a91.1.1788193081897;
        Mon, 31 Aug 2026 09:18:01 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:21dc:72d0:a033:17f7:ad44:4f35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398a2d45bd0sm5115099a91.0.2026.08.31.09.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:18:00 -0700 (PDT)
From: ThangNN99 <ngocthang2710.1999@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	ThangNN99 <ngocthang2710.1999@gmail.com>
Subject: Re: [PATCH] mm/slab: don't use kfree_rcu_sheaf() on PREEMPT_RT again
Date: Mon, 31 Aug 2026 23:17:53 +0700
Message-ID: <20260831161753.7390-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <faac65a7-5c83-4a00-8334-ed26c45a8201@kernel.org>
References: <faac65a7-5c83-4a00-8334-ed26c45a8201@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 746CC180005
X-Stat-Signature: owkp7ufb9tnrpdt76hj7zttjtkktu54d
X-HE-Tag: 1788193083-8562
X-HE-Meta: U2FsdGVkX19Z68oeC8t9LwoP1mDAvLs6veZoYrrx2Oi/KNRY1MXWgRnsiJ5VCfLC605TUgoeRdOQQUiuErTstnn6oa/kOQMunAm4l8nIUIu8TreeZT1gsQNH34MNxNc0tuDUrJY9ixXLXAeLsK6xeuV2Twr/R76fPQ7KNXycDSgKilD3IRv1HUiyMBxPCf02TuPFRyCVtQnT5y3Zf38+8UqgG6tkZXhw3mE0qFhnS/zJHpzzc36PwFR9cRBgDsuG0L+vSJNq2ZTw7LhoiJthfv0NvfB4nrmO/MI5HQAJUlXOmH4VqECGWa37bknRESzbOzb9vAuw0VuFS4Fv35he+b8DmIyo+xvdPp/yefe/DUnO1m2bose93VvzkcRyTLlQ0EY2zmOyBmJjtGXm7UT5wR9k1eBjizz92wZ9oDWrOZ7BGCb1bcAHJBZxJkzil08MZqEFu3HKg3m6VOcc7p89XMxL6Fnp13zHGlI7lmN59XKYbP5A0GCm004DIHN/EGXfp7h9taIjtr6AHSEwhYyIY8/08v46kvuHX1OaTUkrCz77uXMzz5E457mQ0fKtYl+V9LMWAJctKqdz5bVPaBopuJhsvDdc47tr3lJRPgdiVQSdzVgInTgvxVGPIg1UT+3wgiWvYNYKskldldcrC2VsjBT7dwv209btZw8rOSks1U3wTLJhCrJ8JK0O1xP8oKuSc1fEvgnxZ9BEOatW1Pr+bq0Q1qPSwkhDBLHgLrEG59/7fZm9gYxSTmKhXdAeXUVzpxBz+eO4zDwjrHW3ti5bzdO8DOzbaNbX5EfY2nMGRAYC+0sEbDWUxMlpcsLEf5yT1zbJReTpSASYxubOASImdBwZSmHj4dsVxZ2oiVcv0mL7HoiQEBGWPfjLDt6fvA7oNPEDfOz+lGy3It0NBzkMVVVt7OkKH9ZW1Axi0abqfMnzthvt8KZcMTNFZDPVCeRdEweVJUBBNtyBs0c1OPz
 3nuiDipM
 1coDGAQR5jEI/oJQyEltEoX9SLW28H2FCpVhDibZS+HmnBIABRH591rzgYrbS91FGa8A+BQjne9oTo2FkGJASlwmJ/fShtN2ciibCoRXJ0MWq3ai95AhkmVcALLTZH2udyiA38CIBEAiJd2UmZNEL8+ve+p61lLraA4F8CtPZDQ3WA1LGjAEPSlfe0HNocdVjE4VFpBtCd8Bqn6B1BxkPbs56UABCvIJVovGrajujcLiQ61JuprRq0/8g+Uv1wyK7FNDRovZOWFG9ard2kUTeuJRD3AimFAY0nDf4bGvuMjP6OfpUUkvthhgXBrV2SPLDr+vEuJp9j7uIObJ7BMrmoadmcKnfQvEnllNDiYVzupnIVO2Ivtx1L8q8C6HZiqWMBlCIjEZpXTk+tUYGpNOvTN3ajTS++VjOG66m/ps9Hl0J/28YISVdCzW3fkgHKVvUT/EYJiY+I9uxzLwo7POV8NFRcmnEdz/AjRJmOv6CsRtweGXsn1CibIp5LqLnnmM5DE/vK9JpKqsSawZOLU3TMU2QHL7QQMiVv/l019qJ25zGrWlRrfJv4yecsOhNmX1cmte2lsWLhQzKAyw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Vlastimil, this matches what I found and is functionally the
same fix I had in my v3. I built this exact logic (skip
kfree_rcu_sheaf() under CONFIG_PREEMPT_RT in kvfree_call_rcu(), same
dead-code removal in kfree_rcu_sheaf()) against commit 08dbfad3f504
with the syzbot .config and reproduced the original splat with
syzbot's C repro (writing "off" to
/sys/devices/system/cpu/smt/control to trigger the
__balance_push_cpu_stop -> select_fallback_rq ->
cpuset_cpus_allowed_fallback -> set_cpus_allowed_force ->
kvfree_call_rcu chain) — confirmed the exact same lockdep report as
syzbot, then rebuilt with the fix and confirmed the splat no longer
appears while the same code path still executes.

Feel free to add:

Tested-by: ThangNN99 <ngocthang2710.1999@gmail.com>

Thanks for picking this up and for the pi_lock/waitlock explanation,
that's a much more precise description than what I had.

ThangNN99

