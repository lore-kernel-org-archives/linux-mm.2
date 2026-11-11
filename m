Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A862F606A8B5
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iCm0D5T5
Received: by kanga.kvack.org (Postfix)
	id B12B26B05B8; Wed, 11 Nov 2026 18:28:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3B36B05FA; Wed, 11 Nov 2026 18:28:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA856B05FB; Wed, 11 Nov 2026 18:28:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 841BE6B05FA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:28:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14D2480463
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:28:31 +0000 (UTC)
X-FDA: 85424429622.11.DADB52D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3480A18000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:28:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iCm0D5T5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439709;
	b=1yjFYOWn+WTvfkCxekTj0mpt26CgMOoE8QPNP87Kv0W5OACqX6ymkvVlPHBuTREP2DDZzq
	lbg5snb/Mr6bHH6my750OVVdQfSAQmqTLnwhSoic+JvzW+TwTb0NZog76z8l4ulXAvMaHb
	7ysHrwBeO0xCPDL16gZlKUmLM1p7SZc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjKsRt8cRszpgQ0Xyi6phaRtCt9rAnhHaLCwTH4eFiA=;
	b=tU40PriY+g5fPfK9AqmQ3r098gTcwQq0RPPtP6Csni3wiUoS1ubUoc9QJUKRPiPvQppunB
	JOGsyXEBzuM3q4p3lLHX9fa97GCM1Dvf2y9QiUCOtL473OfC9AggJ7QVNXwuLIOl7a1Ch8
	i5P1/BSj9dLX8i5GvcI1z/Dy0UhTEOQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iCm0D5T5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF4EF6553D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788671F00A08
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439708;
	bh=kjKsRt8cRszpgQ0Xyi6phaRtCt9rAnhHaLCwTH4eFiA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iCm0D5T5Ln0cjHZxEusV4a38FXqCDX92CgPRMWeJAdFstQL6vlxX7o/mQmrmbXGua
	 cTmgFcbEBZlF0ot5TiqvAf2P9dWA2K04hDK6k5ZPM/DTo7iJVNETGw4IimsMC0Bkkq
	 YRCKz6yr32I2uZ011ySUFEUGAo9VNCTdf9uFVegqFOo2Ok23SLqNDbpvOPEQCtZwIb
	 aXFGcPMTneR7hf9Uo0S9cuNjMUZUROl85Q4txGD/w/2sHZdYLJQc76OTUUFgsWj9tr
	 MS6san06x6XR8W8mT/HqPppkyEyWkkIyB7npDD34yjfnGPTZBR6kv7WebGa4LEJuYi
	 qc41Vo6zrjXoQ==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c5080ef9b31so21944866b.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:28:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFCu1JqLo+eIy2t5X350rh7x+PEuis75sOfaGCtOId9NaVFZ7WxDi05iljOSZqJ8iXYjBmk92DtqA==@kvack.org
X-Gm-Message-State: APuU4Z803jdHIL8+iK5DadlP+g2f/0zWZqHX+YVGFsgrotOvBWcpJriG
	erBrtLpj5EklEYhr46bTv8Rk7Cp8fQq5T0DogJ/A1cujR15U/HZAdD6/e/o/tvzRHfWY3TZ2AJp
	NLqFmgabSUZqAffTFXIBqx5DUAcvGq+A=
X-Received: by 2002:a17:907:7ba2:b0:c46:ba33:1f0a with SMTP id
 a640c23a62f3a-c5066c957f9mr308104966b.31.1794439707397; Wed, 11 Nov 2026
 15:28:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai>
In-Reply-To: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 11 Nov 2026 15:28:15 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP1o+L-akRDJx80bgGj8bf9rdN09t5upPfkduSmNKwpKQ@mail.gmail.com>
X-Gm-Features: AclHuK_hFEguqcApzcHoN8gE28_RQtMAzD_ff31LFqIL3UJmzagtdSNw4U0_8qI
Message-ID: <CAO9r8zP1o+L-akRDJx80bgGj8bf9rdN09t5upPfkduSmNKwpKQ@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: honor zero cgroup limits after successful reclaim
To: ts@perfloop.ai
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	roman.gushchin@linux.dev, tj@kernel.org, chengming.zhou@linux.dev, 
	mkoutny@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	cerasuolodomenico@gmail.com, linux-kselftest@vger.kernel.org, 
	shuah@kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3480A18000A
X-Rspamd-Server: rspam12
X-Stat-Signature: x71zhuk7unb4hqyb9ju7iskbfskia46c
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794439709-265709
X-HE-Meta: U2FsdGVkX1/xXMbTlqYQjJG4jE124MSIVuSZVqi2GkRpyxY4q1PF9VDtAq5MWQaZXjWwRbIdaVD8CrAt2+/HWWu6Yt6p3eCQkIp9rAp2Y9AHkQvL3uFUkxps+FNdXREiQP2YSWP4P+OZORnbi+pa6XxzIziceD+xb9kkRTgt47ROwy8Y+XyDosgV/YBD+XlRlM7Yb2VTVQ4DXJc6/ARArTe5imGef3HR8UZl0NHBi4Cw4yQbslpH3IidbKBs69eIUBuqEBkQMj+K/tqsXkZ/+WumSNt8vYJHxWuCYh2ruJFi0XHbmh96W5aiTTi/cSNtnSzxYod4tkXNU5zOBq5fSD0ur1U6OUUI++U2uAkE0TSMqj8WizvjXcWWC5LJTJIzqC2WQhUq8vg2WhW+kfqeef8/K0wvNkpa8wFSuaDd9xAjZtKlVMqR9fif7a5istt852AIOz+R1DFM6S5RKh/o7oQiEV6Vf11sLrIVyJtOkCdFexTsiw/Ov10eqZMm30GyWK+sG2wYR2oGrk/OlehrumRqnHnxKQZeqzcovqjWDNk1AguhhxbJvrn2destc0AqaNvn2SZAjDi51fCLO8iypxycaYwJceuXAqre1Xg0Ta+vl/Dr4VD7lPvVUB+V5Wq5bWxUthSbt/U/X2LHhN5tWhNLcj9jBrPJ1lSZpLkYLuUpZMS+8jRda3hyNtjCjHC/2D/FT+zpwydZq/aXNxDruqObzzewHC+JniLfCyNQSn/UEIJNh8Ob4XWN5kLPzXiQpqiWmgTS4HxPl6rV+EtJnau7YDMQz6uH3DU9RjgLYGhggPi4DiTOFoZ2CwQTqpl/Ax1j8rc6qHyTLO0+dsPk3nDAcW1ezfuPBUjNvGtqHgOL3duiOpq/4f9GcLOhU5MwasPMXmBVlTI9Wq1gLoNO4hFTnI0BvV0MhgIi9UDDFvrTRvNhK73kF7M1glqEfjcWXsc9HYz3U0GWgdfchV+
 4w4MWJQE
 jbY03mZWXK71tDOcnjxv0o6fwWblX2yYu1GkRM6VKnIV8852UAtspdDm/eHtJtFg0YFX58/Gx+W0GLQ++6muHl5fB4ZQReozA+rbJN+DEIu6WqzcjLy+N9h3rw2gv4swbgLxhh63bDRIjFsVv0udRgOzTgGe2XQrfUFE3pFIx3KreirtWa9jg8v/4xikCNWs9n0KLegxOkKJTt/v02jFcJSNJ8wpkC1iptgcQ3In14xmJz8ESy8BR+J5gLotKd0Y+iVEAjFfc5yAGzvTTHcIT/D4fPeIt+qsNZewbVoKUMDLVeaCz8wfiae7VRWbNZYnXHC7T44/yFtMMJ06fd6rW/ENslIl9aJx+MA7HgKBHD9WjYsMvbHhxly8wbLVqptK2Z09v4Z9WliYjIjiQc6tjwNl+oSXXDbQmX4nF7gfqWTVXigJlHvcrwFLXOOkAm36B8qOY2Az3v3oFKwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 3:23=E2=80=AFPM Tom=C3=A1s Senart via B4 Relay
<devnull+ts.perfloop.ai@kernel.org> wrote:
>
> From: Tom=C3=A1s Senart <ts@perfloop.ai>
>
> Commit a65b0e7607cc ("zswap: make shrinking memcg-aware") lets a store
> proceed after a successful cgroup reclaim. That also lets a cgroup
> whose memory.zswap.max was lowered to zero replace an old entry with a
> newly compressed page, although zswap is disabled for that hierarchy.

Why is that a problem? Setting memory.zswap.max to 0 while the cgroup
has active swapping processes is naturally racy. The limit can be set
to 0 right after we check it again anyway?

