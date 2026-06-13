Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3357ACD98CE
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 00:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478BC6B0005; Fri, 12 Jun 2026 20:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451776B008A; Fri, 12 Jun 2026 20:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E0C6B008C; Fri, 12 Jun 2026 20:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26DC46B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 20:09:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C26FDC15F6
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:09:02 +0000 (UTC)
X-FDA: 84872954124.01.4A0B242
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3926C180002
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:09:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WT/RpASS";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781309341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwgdDxjpHcf51uQFCyHB9zZ8TZlVfxL9kvGTnnuc2og=;
	b=RkWiM9mHVCwBIySzuTQPiHr3HHIum0DqhIJIjC7MNRSWr6a8WydXJ0avG1SJQAZgeDQbwm
	2HIxbDhTHWsJ2D2pjuBgjphWnU5QLbEBD5tBwik2jD9CN42efXPbDG7X9g3UvTajpJzK8m
	2WoXXOwaoVIhO9hneW8RNNcX1Kv9LOY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WT/RpASS";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781309341;
	b=ZDRpEE8aUu24JVlNlvZKJoHSBQ5m8gZoA+fvLyHB/LTJhj+JbEbOq8PCdtRiV8VpedRA5L
	481B4vNr0muw/PnY2mRu7TeQUCUHZ8zMx7k0O9nGgzSiUqJ/l9/I75akIBpREX0xeNSX7I
	lSVjO1EVjPigDy6h/hzQ9tNzhNgBkgc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92C8860008;
	Sat, 13 Jun 2026 00:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8ABC1F000E9;
	Sat, 13 Jun 2026 00:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781309340;
	bh=jwgdDxjpHcf51uQFCyHB9zZ8TZlVfxL9kvGTnnuc2og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WT/RpASSQHJBF/FCpzT7VvJcI/8vJCsTJVgtWdnX/u6SnGSXgt+9VBbPNygOHOuM3
	 Xi5O97z8PSzS9rDITHCy/37Y0tPkWdYCaBgFOyfL8G0LHF26aTZ9m1nvmmgMCb4aUo
	 4qxIbE4eYeEf9BA4rGrHfN1iz9LdP3D76YDWfmjYZsg9HyuXx1AMJtdwUnYfvyOgsn
	 85GMHHWMt7zp8woZNLRcNrCwyD7bu4TpaKoJWLRiWEDY8A9xBixHpRlwbClICFyzJ0
	 G2JLUEcyClWT3DaxJHlngGsOD25ag4WYye+S1Eu+2p/9OMU+NDO3xfOBUS97aMINZV
	 BJJS2sdZA/EqQ==
From: SeongJae Park <sj@kernel.org>
To: Shardul Deshpande <iamsharduld@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Docs/mm/damon/design: fix a typo in the Address Unit section
Date: Fri, 12 Jun 2026 17:08:50 -0700
Message-ID: <20260613000850.935-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260612154054.720363-1-iamsharduld@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3926C180002
X-Stat-Signature: 53jytwss4ebzzhswkmoma67skzq8obgf
X-Rspam-User: 
X-HE-Tag: 1781309341-295975
X-HE-Meta: U2FsdGVkX18v2bgHIOHo+lFB8Mh2YCbsn5Rn3RwHtnHdwkYLYdadLS/LKWlxZtGAg/o0vbBctGVTlKK7NTQzOdu3MMJyiJIJfR8LL7MjCy+MVM3/iA09BIAMptBtxnvlxhHa7UEbeXj7qeApx7LshcB3+5QMob3rjWx4S1Qr7Zd75PWXdYgT+cAgR6x8H9/IE10JFoukmg1RS11W1/5ONqcVGI6jcz4iM5pFmJp2dPYT6/DNB82SpDq+MNV9x+AIcArM0bCDJVLSzmoD6YZr1BpvuY8/DVlX5reZJxh8f8eK2rTtdwvIMiDvYjLmIVT/sZlf2NsvCLGbF98Og7tQPMXsANXtURq6ubUx/nLuwiChQ0Cij+HGLjyL18USwbZJoYQ/tE3RqUr4eb6mkHXnqr/F/lg5uxohjUHFdr603IaqhWmGcWriwhMhD2roAjYO+LOzdpmw5CHezt4NB9pgxvO6bNeB0TBV1GS+eznt84jALcAkod8KvczXCoZCTIl3l5Idu1Lqt6XZfx7v9yFO6WsMPcFrxxn80OoPboqkHKFguZJ3DcIuIv/GZ0HZh3QoRlIkshuAX2GIhfC0Lu9plWhU2kuQ99CZSo+Rb6i3V3HlOsEYY9/0N+oRORrMV0EzC9YWHjTf2tfvupbWsRgn0GHynQdH904EFB9mivDtlf0+QkpKG5hWK74MJoYposbnE07AHcK/C+Nc3uCXisK38znBPqFWB62Yt1IbJLXxbVLXiO+iKE5vGYgiUyUmvJb8/z0JvtBGP36ld7JRi4kcxPBaiV+f6J+RH/ZPQIkg02rQuLPJE20LNCUkC/dF4ZLpDHCC6Lb7d2wv9P22Mx683Zge8vyNVT1vCl+6Ey7W+k5siQ33dXk0im6yWFytZnmVI2HsBLTHert6t2TAVpnqxmGb2S7k4H0TQJYtZMJkuhO5cqdnJK47tocl/lRJOnyB8CFSr/T5DbeoxHY6G3z
 CyiB6IwN
 21mFim1UvbOpI630HwssAi4s+4c/can0u4hT/GsnvLJeXxtKx2QnnvuJ+XdNBwkuEHF2YMAZgdwEOv1WLuMjA2GCDVAr0hL0FNxfRjN458fZb+4AX82mT3+UDtwEMjFCtN6iAc1FG8eSKRRokKBLdY7b6/iSVKh3Wei/5TYBTTa8eHK0GVYwye6qGCwHOGwEGCFLhnXkZ2U/NPEp6wuurXjLo0rsHySij+X7hmGF5PKXJGJE9k+3vsGx1yDvLKEsnk+Vv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 21:10:54 +0530 Shardul Deshpande <iamsharduld@gmail.com> wrote:

> The "Address Unit" section misspelled the C type that the DAMON core
> layer uses for monitoring target address ranges.  Correct it to read
> "unsigned long".

Thank you!  I found you sent another patch having this change following
Andrew's comment.  So I reviewed there.

[1] https://lore.kernel.org/20260613000715.791-1-sj@kernel.org


Thanks,
SJ

[...]

