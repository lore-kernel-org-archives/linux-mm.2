Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD402606A323
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 20:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=gIAe7HUF
Received: by kanga.kvack.org (Postfix)
	id E68946B0559; Tue, 20 Oct 2026 16:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1B606B055A; Tue, 20 Oct 2026 16:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08D86B055B; Tue, 20 Oct 2026 16:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A10066B0559
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:27:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF64980304
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:27:53 +0000 (UTC)
X-FDA: 85344140826.16.4203D9E
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 21A58A0006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:27:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gIAe7HUF;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792528072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j1azJ827J4napxY8pkAKVpOgDxEHSu+Tz2FVu6oeb9k=;
	b=noT+AWrnwclK9c7OOne6oKhpV3bdeja4mnj6M4dTotsThcp0owCXCwlA4k43/dbb31Pu4b
	eh6004YSdDGFqtjazBbdLDfGdGW4x5NE8VByLYRev51u/oPafzPdAwb5t5edRK1I6LAius
	P3tOj67MY0qvPONg8jtP2KUmlZH15zg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gIAe7HUF;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792528072;
	b=mq6K77S1AanqoQm3KlFmKe34XgiBvkvEHtEcIpGwVKeQdG6CRUsg9ueYlN8DpyiYpdwDna
	ik8SKDdRR+FslovAcr+lCnY2x2XgMbDoNENImHOOQnTMpgT5m7dUvf7/6OrXrYaaVValwy
	OF5CZf0s0tkobEbWw2UJgkiKUJ+XvoQ=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5365f9a04c5so1075311cf.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792528071; x=1793132871; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=j1azJ827J4napxY8pkAKVpOgDxEHSu+Tz2FVu6oeb9k=;
        b=gIAe7HUFdunPFUrwZkvpbzs4YBHo6+EdoeDXErUaiihydZtA0WvZ66Yz8qUIZquxuo
         VacjQTwB8xDyMB7PYkACs1T1xggoUxni4P2fQf0AVeGeZau3ProwXDfqk+C8w5eI74dr
         2PxdpYqf5bNsTbeFjgsIR/PFeh3uSwN/1r/VVsNty6TS4wcBWh2w9pDxn3dc4EUuDhOL
         /ZA/EdPXc8LCcHn85otvb4Oaddw/9wtzn6DdEEEiLjm8XhYZbGjq8/8reQjB4ScQF+nK
         xIf5u37GS423HfEWR4+AwwZ+1Q4WsRP6zi25Hoo7F2QjPiQ3kxxE9NxpvRYYLdxS7ajP
         mjxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792528071; x=1793132871;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j1azJ827J4napxY8pkAKVpOgDxEHSu+Tz2FVu6oeb9k=;
        b=eV6RpK7DcF8NVEjikj8+SEKraup9CUgzuvGVl9v5QOvwNcejvdKQjniWjDdDhM0C15
         N64SDeYMExJpvl5SNm8ToaCF0CzYQTGr94GcPQpaCqIN4+4vefku0sX+KoQ2eIbgpu5q
         0KfhSsIhf5KRBkZn9Ir4847+zrT1bdYWJW/h+FCLM/uQZ8qupj+dSpei5T8r2DIVUr+k
         UqmTrDza8yO4mH7gHqryk8tNcN5xZ6k+JfYUk5MU5HqXfXF5nful197EIcI72mREUV1Z
         0+VuNAq49GDcck9o61IMn2vINK4QOvWAjsrLoMpt3YJUnnHmNTA2HxxD/8XbdOWi3jVX
         7mlw==
X-Forwarded-Encrypted: i=1; AKwUvBw7ISXldVrUXJP9286zEuTDL+ED6TFrOuOP801xNbBiQ4eEJT1uIjCNnVz20I19dOr8IbRw+YxvNA==@kvack.org
X-Gm-Message-State: AFq9FYLZEV18NVguyh2Blau1eVor8+68tVRTZWzJ/zuthTJbNRQMhobm
	5qY+ZnEd3nrnWjT7+UIcARZDWks2edUIrG+Eg4ppc711oJeGroMFfq13Tj9Xez3J2iY=
X-Gm-Gg: AYBFou00symk7HwTnl6e6d941t3G2VsUeUN6mFuW0lgA69H2I7nCSSXqEHOlrWRmWEV
	OARq3vBi17qFVve6ZcK+HV9eF2X4x+8mdV85Cp6iXL4V0sD/pDjhcJ+pCeczgWIDpwOhKueekF1
	wpQBbGmHajhUr4x8HHFyCUTcYoxWrE0x8TK57Jdd9F4cDoEOS46gsA5OPKH42KrsHYyYcoEhAPT
	fxOFqDZztJf63KtZ+7JNmpEjcxKy/0ZKoyOCh57CHozjDamMzFIuiUHyFedWQ7DqH7c6XDqvh8e
	7XxkOuSV9YEK1Chv2lJGsh0oY/3F6uT2poB0u7w6l1twJjCL5Duek+JAqK14lyE0oNQSTpU5nbb
	691oCEI7N8veqF14oZA3E3OLgd+YyNAIf+3Ymjl7uThcFUZf6zCvsPaI/xWfgcqk1YatUnTx0IW
	7SDU7wRb/wvushhjiNQaLWmgzML4yOSALEMjr5xxm2qgGLiCvsXJfMbv8T1e5TbexIJjzd/RsrV
	pSj6CpvVM5fNCwmGZj+EhUO9/rDhyEOBUsfrinkgCTVZqf+L0dGG3LS+neDaCmTLmiWaM79caTR
	eyRHxD/acqKgeM6OWOmsJ1ZfZmo5mkEja4nWqmCi51COHyu2
X-Received: by 2002:ac8:5d0e:0:b0:530:8853:1be5 with SMTP id d75a77b69052e-53645c32ef4mr200533381cf.10.1792528071192;
        Tue, 20 Oct 2026 13:27:51 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53698bb8234sm4300751cf.24.2026.10.20.13.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 13:27:50 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/5] mm/page_alloc: validate zonelist slots against
 concurrent rebuilds
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, 
 mgorman@techsingularity.net, jiang.liu@huawei.com, Bessel.Wang@huawei.com, 
 stable@vger.kernel.org
In-Reply-To: <45ef34c7-eea5-4813-b54f-3e34675697b5@kernel.org>
References: <20261019172346.3344005-1-gourry@gourry.net>
 <20261019172346.3344005-3-gourry@gourry.net>
 <45ef34c7-eea5-4813-b54f-3e34675697b5@kernel.org>
Date: Tue, 20 Oct 2026 16:27:47 -0400
Message-Id: <179252806771.851873.10455974025763071382.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 21A58A0006
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: w1w7dae8g66156qkz4r3m1uuc1nfjysj
X-HE-Tag: 1792528071-14223
X-HE-Meta: U2FsdGVkX19cE0AuSOX8y8QgQ9F1UqU3lgFoGxlrPMrxPriU6a1EKP77lH970Q3U0mU/kKWKYmtuoEJ8hd+MZXqT0PKX8sZl01Ejx6GsWPnnmhS7fIAsjF7NLYeTyE+8aXOzJZHmOkt4k7qnGi9x2KyGtatapkq5GzqFDX7Gg4guK5uUFxo6nB40x8JYK/NRZjOH+LFawU4JvlJMSN7Mmt5E4SG28NPjXj6P6YOpoOPJPpxzGJ+BQBXzGZfm1jrCf8CHoSgXkp3xfT6uuCXh+q/cU9kO/o6UF0r+4Cpc7pLInYABWft8+fCi8PSZcK4U1YM9Tg5qiF6lHm1CSH2QL/q8KWUHk3IYCfDRLQESQZ6LSEYiWyHpIZ3cCKi7VSuZ76VO2GundvVISjKwA+ZynEKm+3NKdXbXxoKp5wAGEYCl+9zCuboBNwbO8NJtVpxxf3quiHzhclQL3lLPLT+qiQauoI7zVX+/kaD28SE8wpqBTGOJ9p114CbIuHqieUqooftOBLY0SKRDpSbJnxy3ngagRq1EZNfdT3X6s+Y2k+PXVcqq8n+Nd+g1P4yCSRnhQJFmhsqQLKQRFtot13bkTYD13BeCDQcuF9uaNENAhPgEl+MZeLFCMbYnr84vxDvbiq6hBGsbv3NZHRHVznQ+BUrD1e9ijf+W8amIJGIfbYmGe8hBk71P2eAITx6ogY1RZRLSGRCsatwEtAmmAx9N2vr8hRLolyMxM9l5pfBldKYhMnNRoTTHLyCP2aqjxIE3JAH5pjmaiSdA72nG5vgu2qQyLWoB6uGsFP+BDyFmusaltlZCb+/OM0+gjlBH+kEZEA1wPwzVxuLQB7yVLjfWjfeZp3V3BsmzdDxWfehzjeYaIiHeq8Yiwx1iD/T71i7UDOQbY1pe0BC8lhz0PgmpS237OT6Ivcy5+2yeZDJ2WHoydMi4dHblP5atLbtcoBU36zmk+5I8867b6G0dWvg
 YHKwh0Je
 z/o59Qr79wwsI6Xl0j99XOGQkT7P4T82sNQ98KElEFnB0rNDyEgIMjsZV3sFUtnWvxyKZLbNmVq505gkh/SQcAnGknE0/176cALxL4BvjRam+ipAuz8FerYKsIx3heW/GEz4hYjCfgIbFF27lKYrJ81LO0QyUhT4ZzfZMkwO3MEjEkpl8Hk6q2EYa1aWKEnZNVwxq6N3uU7zaCM98/i78RGrRkZ2tH4U3uSAkpjNb0C1TOTSBpVQXhx5HEIzXUmf6BMmNI88EgzYLPcFMpiVgWygoEKeOj6DX4pKhUqMBx7AfMpJUU2URmZSBqu5YId4DjhbOq62Er8DW4ucRCEUoN/es1br7qvt3wCsv3CLEnhc/D9CMoEYDCCrWlJYlPpM2NolERiI+vn3Sldl5eUvow/JSOp9WmhI6pg2cV5AZxh18iJEfyMv3COdZ1Rc0Dmeu6hmNspcAdNvT2aquoDE7YSDQCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-20 17:22 +0200, Vlastimil Babka (SUSE) wrote:
> On 10/19/26 19:23, Gregory Price (Meta) wrote:
> Furthermore, since we have the zonelist_update_seq anyway, wouldn't it be
> better to use it to avoid these kinds of races rather than the more tricky
> way of relying on what exact updates in what order can derail the allocator
> side and trying to protect against those specifically?
> 

Sorry also meant to note that from my reading, zonelist_update_seq
presently only gets checked on failure, but maybe we could re-use it on
success?  Let me see.

~Gregory

-- 
Gregory Price (Meta) <gourry@gourry.net>

