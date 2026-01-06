Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B5EC47BD5
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 09:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D6836B0005; Tue,  6 Jan 2026 04:49:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AE1C6B0088; Tue,  6 Jan 2026 04:49:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7DE6B008A; Tue,  6 Jan 2026 04:49:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 693186B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:49:33 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16F081AA1C7
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:49:33 +0000 (UTC)
X-FDA: 84301066626.17.0587C92
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 113218000B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:49:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=F3mCvekL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767692971; a=rsa-sha256;
	cv=none;
	b=IC8diCsiUpE8TA/f6uzFpUN5Iv1q4aoYMliRmbEgz7JqOrdI0qZbz5zLmifv+g40/OLsMg
	xNOdVMkLnM+83Ukc/043qxQC1wJSTE3VYg2rvwW2h69SED9zX7Qwt1dr96NjARtDAtJMFI
	HpY9yV9GY1h3Gzsd4sCNyl0hU01bikc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=F3mCvekL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767692971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLXye61rwdrPbJ2pzSaDKjm79SWQPJ9fss4ZNFNRnnc=;
	b=5b9Cyg46ciF04vDtIhz2NRLtwsGMbW3iSIJmEgRIko/0lPHRpS8Xs4mndhHfAfN3LyPA7U
	2ILZKdTB648ckpXH1WiqRu49tcmNN5Jab6BguXKE0gT21i71cLdv37ZfW6smy4eKXtQCUe
	GmXBfofBv75P5CRE74I3wfJO8+PMIE4=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42fb2314f52so336801f8f.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 01:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767692970; x=1768297770; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hLXye61rwdrPbJ2pzSaDKjm79SWQPJ9fss4ZNFNRnnc=;
        b=F3mCvekL/FwcIZvvuuT+MpCt2xnjFbSohBvt2Or6iYHkRhfwFhLfchrsIwB8gZAOoy
         wbiitpUI2H6QPylYMNBl8QhOk+AE4bNUwr+rW1bhc40ZpLuYDV6gy+9evX4x/uT+vtfw
         1aaTsjFjVw7sVy08hNTSsPVjR8t334jl9e/GPRKzKvFtZS73EyCslkNaCvFcXG7clsH4
         Ncw2BhZZPc9lpJsVFEcVxN5Mqd3Q190bnHS3M/wbb1qPKuBJfxzaH3nDZm9MktdjIvGe
         DZtpit4SIkDW5GMbgfQRIwz9IqH0W+C6hg0GdTrvL3c9QVg6CTU9Vf5M55P48iAGRVJr
         vS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767692970; x=1768297770;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hLXye61rwdrPbJ2pzSaDKjm79SWQPJ9fss4ZNFNRnnc=;
        b=CuPjHJLpQwljnafRpUP6povfzmtHkCcDJ/D7g+JoDtM3BB3fdf4UO3ZFRJZfydwrXx
         FgPv4T7xOWP07nLFJ2gOq6j2FPXnpKCRARa2afGuTE+7VMcCglUi3WcbNMM6F8QWxUc1
         PX8Avm89mgz7emsZ7AjgpgCBGZcVbIuZlq3VS1CMaaOhMgdEbhlCmOfZUdyu6X+w65gx
         7oZ6EsT1AK1C2+bntr95WwqRFY/4vQYQWksTux4FjYGNxexQv9+UVDMKK8pYuhcUxSml
         jPg9AQWT0HiU9jPKtDFGk4oj+1KVfMYr3SPhT2xIaM+FXbyqHTHJUD5dXDB6xvT/8nyo
         hWUA==
X-Forwarded-Encrypted: i=1; AJvYcCVR2w44fO9CgCTpFTLz1gdRXMfBj70kZmUDdfiMNSVc0B2FfP4vojqTAvhwAjp2YCKqJfQSOEWS3g==@kvack.org
X-Gm-Message-State: AOJu0YzMH6ucxyym9q3mYmugEbI8M4E3fQTcgokI933iAY7KrPV+u183
	8pgVawqkWA2oDUQ1sQc84uTq9/BpJ4eC7zk7o89+RFzdtaJXfa42PgAqk6ssiXLdrNk=
X-Gm-Gg: AY/fxX7dSlZxgOf6xijnlFIwP7Vgjapc33gh2X68+isyevJxnnmU2Uh7ZM6a2+4BDxa
	aZx8EtxQTQslBiskU5aaYJQU2B32Lf4KsH9XFRbyJ/mf4Pl2Mopq/wjAibf5lUOQ3+zSqz32+qY
	GCZUL2X3CxDRiGSmbCiQDftKf+aM2vJ14ddUqYzX7zr6ZRW8Jm5o+Sa5uPQpPMnKlOx0Mj0NGQI
	7/9w7DY+M0HNKU7IHPGnJ7x4iavKlH6cwrV4NV5Xd+urvsSQc7I3eFj/L+u+Cw/kqHmqd/Vt1je
	92sLHjB8E1dRB6V5bHQIntma9y7PwQ+KkwIyoDyGL78ZjSGf3/OjgWj+d9ALws3onjEKR0lNMa5
	jbavHS573Ip3W9hSkSPdlY7LCOAYZE0YOFSZF5X8/QzjKrMy8X8rG/a6/3LwS4iO6XSdwDwHFxx
	ElhEYwHXwdl4ZzZe/UjIufABBa
X-Google-Smtp-Source: AGHT+IGDB7ogjDO7PVr0sLCSJzXOWSS+WkgmJxvNiw4IgeCz5dk50kn1D15alayXabyMi1PwRKaRhA==
X-Received: by 2002:a5d:5f51:0:b0:429:ba48:4d8 with SMTP id ffacd0b85a97d-432bca31225mr3446585f8f.25.1767692969633;
        Tue, 06 Jan 2026 01:49:29 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ee893sm3339336f8f.37.2026.01.06.01.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 01:49:29 -0800 (PST)
Date: Tue, 6 Jan 2026 10:49:28 +0100
From: Michal Hocko <mhocko@suse.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-ID: <aVzaqAZ5Wagh5cDQ@tiehlicka>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
 <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
 <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
 <u2llnnpmpsgarwrt74ffgo3cuwe4apdbeh5hkclzbh5gykwltb@whb7uuj7ub5i>
 <e93c75cb1a46a60ec415215c555312c82b9145ac@linux.dev>
 <gd7qbyakigogdbfxkujtc2ewwfzbwudn2l6vqkbkttv46wkfrd@nqseltiu2do5>
 <d7df4e26841d83154f2cc2487d5acbaf2ff2cc27@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7df4e26841d83154f2cc2487d5acbaf2ff2cc27@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 113218000B
X-Stat-Signature: xydn5doirr9jq1tzhxhk5u6yd6jwxibc
X-HE-Tag: 1767692970-902259
X-HE-Meta: U2FsdGVkX1/Ley0F2EwlRI87qSkX4xAiGHJgNgA4/7CcQzsq+f6ep5v7z9H9vUj7xDbwElkfyWg6Q0CTvn0wmRKvut8jpv/L8fggGJOmOAtidxOofSMMt1LYgdKJ6zYmgzEiNocdGYfx7i7oZUkX8T2bX7gGb6xXA9Xs++jJjS+oqzP132bLNgSS5oucoHMUP2jB1DBaqtSnCngCJ8seXD7BK0hBSpdDCxkJBEur18RxROWFDEUYvJBJFNCM0d+cqrFWUSZb3DHicI0GAAWWS6AwdwSFc1fmljzt433Q8CsbzpI+/GhkaS/I0fzPkYFbTIjh5uS+9gH76ufscqq5c2dzeW39VUVkR8f2hv0lRJViKtwKqHNnBqjvNSG6BraoBDyQf99iSMNF0L6bnzt1uRs/10Asri+3D76anpch9EDNzkp2PBo0kZ33QrBn+xtPoz26I34QM//dR/y9cMVxrmMoMMyixrs5OKVJYVte9c0zWBOf07+Vbzn3yd5++/TuV5Xcy2RBiwb+dDa0VUTxf3P6ST26oUnXAv+h8j1m7uqsqR//lPz7pNyhv7dW80S9tlX6KLtZNmOkbZvU1v0AeHv/bshRP2CWWoqUWJLNDlymYhj4eTiKxqGZ6Dr80XdwJbcBnCjZ8ltt2i+62WHOdxszpXgHs2fy0MI8J60p674UlYLusKPW+JxmkyWtRgwNTbl+dOBC2c1G578kAphvaIHKpnu63UB1YLRsrB9oZRLvSPVBn1Yy9sUXwoZI9R5nx5RDYwFc+Rv1PyXjFKmaYgcgbHN8qxTlQMpxHd+54x4uWhO8j2N/9MOXp1oe0+6E62NBL1XTxqV1c9ruDKBYBjc7G8NmjEb9biewgSZzn9FSUYSCieV/rOQhtlqz+NqnTy5D91lMJT724v5DtEGWX0haE59OE8kGmluJIyPBgWFv40HfmsylHtMASEzbnbrYBc4l/M5Ky8a99U15stt
 TuAx6ERM
 IqS7nPrLxtLB/sUdZC4KSVGPS8x06KbfcM7PV5jmnRGybsJqIY0k1j5nG4S4LmOO+xXDNNDxwmM54Fivow2RnaeT2MNjrJdsHdJATiQq2fPNOxZr+G9hdGSt9z+LdLE0Lcj9alJPzSc5/W6eJpKlsdQyNNArSRnT+uxAk60BlMl1/G0EgRiAQh53z4cV9qtDyf1C2piGJkePI+o8fUlhSEpmhDqNPB0tv/mMsMM34souQsAQifawuCTbokekcvoWjklYMHt3sVQWXFMPcDgPNrjilH1oV3QFTVyWrUj6uXRVVfYuJrBw/vcnC+WZ4aRs3TVSofG6XdTMu+lFTwPVHeyzItQUYgF+0HBt881JhSFQUmhv+RBlsNr0miRCdU7Igos7IAcWbSvm19TBTcqBVpc9Cpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 06-01-26 05:25:42, Jiayuan Chen wrote:
> That said, I believe this patch is still a valid fix on its own - resetting kswapd_failures
> when the node is not actually balanced doesn't seem like correct behavior regardless of the
> broader context.

Originally I was more inclined to opt out memcg reclaim from reseting
kswapd retry counter but the more I am thiking about that the more your
patch makes sense to me. 

The reason being that it handles both memcg and global direct reclaims
in the same way which makes the logic easier to follow. Afterall the
primary purpose is to resurrect kswapd after we can see there is a
better chance to reclaim something for kswapd. Until that moment direct
reclaim is the only reclaim mechanism.

Relying on pgdat_balanced might lead to re-enabling kswapd way much
later while memory reclaim would be still mostly direct reclaim bound -
thus increase allocation latencies.

If we wanted to do better we would need to evaluate recent
refaults/thrashing behavior but even then I am not sure we can make a
good cut off.

So in the end pgdat_balanced approach seems worth trying and see whether
this could cause any corner cases.
-- 
Michal Hocko
SUSE Labs

