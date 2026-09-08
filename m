Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B13DC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 18:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C61D6B008C; Tue,  8 Sep 2026 14:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5774A6B0092; Tue,  8 Sep 2026 14:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4690F6B0093; Tue,  8 Sep 2026 14:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 153006B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:27:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4A90A07B1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:27:09 +0000 (UTC)
X-FDA: 85191426978.10.A76B9F8
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id CB21240008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:27:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZC5tS+gH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788892027;
	b=XZJzw5MWqO7VExbMhuLOPZ19DHUoflh32hpMUhbqegBoymyOrIT+pn+X0Drytmg43IKl5B
	lAZ+fonZ/wD7w+lEA1dzJnpCkqBvxh86DBlIFdjsk3kBKO6mWT3YQHYnjl4l/CoPMdgOlg
	g1dBYLB+i2SgBBghaJOG4TfkrqKhoyc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZC5tS+gH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788892027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/edzti1+6WAlEVmYxG0FqqQ4ZuFKkllgKBweZCBdkNc=;
	b=5ghKDEbs1SKyfnd/ZAJAeryBAUdIGRM5pdw9F74DqljT2kwgzIHrE+drg6TtKw5KHDZ9Ze
	Yt1h0Pb4jN1zO5srmLMsk3KMBPYXLrnB9ILKvPRZ1C/ccek7JWidQN97OGvwe0oFni7D+8
	enf3W5S+3g1AHotVLeTDHRX2ZoewLoY=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso62091175e9.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:27:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788892026; cv=none;
        d=google.com; s=arc-20260327;
        b=KBUqAKoZZXfnEii6UCQI3rv7gNnsMcjzlIQv7krnr7qGL8gUSkQ3DJFZ2XQmFmKy1+
         2wn6KN4sS1d2rabGmDW0TIW5ENhsT10kkR5ggKxw3sB41d4Qp2Ii+1ztuEH447bGoa0K
         ++5k9m9oSmcyDwsJhBphyFOAdju3zp1i+yte8aJ9zPPgwJnJzw1lUxg6e+9hJVlleBW4
         2IuyjKGren+bVsMyQo8D834w9ira4gE0dz+vDDoEs9+2Rg4YQjvsZH386qp6pUHx7LrQ
         rl2krIife3bxDK6EZIiX/sKJU3Lz1RS6SQjh7TcfuSd/oLMY5CJdsODLyPKRxBDvwWtY
         Xzrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/edzti1+6WAlEVmYxG0FqqQ4ZuFKkllgKBweZCBdkNc=;
        fh=1+fz6vp8YmmCJV6mmDxq+ylHAFI+UTbmRabZ5ayCfJo=;
        b=YW/e6FHKR/W/0MlXYnD6My2WEGDvBcKZwpMmhMkZdc9XmTAP7EM6UNcKo55+aWqToh
         t1EcXjMBEojxMfTitp5tJxI4uGEhSjHxQQgGdF7bIlyNIAyk4k0Omx0+121iHnFFzc1r
         pkvw5KqdWmGoFrMIjNrScFxyzuKMMFTYuxr1ieY1uUpMBEEpxtd3e3TGaIBJ0xfbbBfW
         WQpf9hgEAqqEeLY1Bxkw7iP3RdpICFSDLFfRqaPpNSQH5zYr82vitZCEC9U/sI3X//22
         OCzwJVl03Ap37dV+/WMRMnre8cxsivrN5eBGuMYTcWCMpOo8yNXOBih5A0rhIhb9dfPg
         5pRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788892026; x=1789496826; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/edzti1+6WAlEVmYxG0FqqQ4ZuFKkllgKBweZCBdkNc=;
        b=ZC5tS+gH6DYMwMX83MeScmm64jslYNNl3gooOZUntxafY7XmhW5Kzsdinai917A892
         YBoVAXOLKjWWiwGNhflEp/uL/ZK7u+pM2PYvN81G5gZlCfIYoM1y+yDbN3MHoTK6gh73
         WE+kdu2sfOPzdnMgLTX5rXQrqsHr71mTAsfQolrYA4RtWYWl5byRQvP6o9/wo3rIwvlg
         DiOusGEQTrO3xoxt2OMcKRSveEisc775ygGMPIRIiXM/B6FU6H0ah10EByETMM1U2e7w
         V2lYSEy+tXz3WOZdXCXZulMoixeE5XJ0Nj7ihi3drAYnfKdLXbguphoBSCvIIwdrztz5
         4Lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788892026; x=1789496826;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/edzti1+6WAlEVmYxG0FqqQ4ZuFKkllgKBweZCBdkNc=;
        b=qp55hq8xfL4DFromNRPlsMupvARMaR0m+SOKxaGmWy9AXQC3MzjQqYBwEPKMELwD56
         VVOXa+xh2EH2ZqJl8t9xPCc7QRdIfHC+hAUPeIt4KLc1ePiMYrWnaiWvCMt9vpWOpsKm
         RJhwR3mZChoM7kPOGvf41+F5p0UcmtAHJikFk10nex2DJm96ti6lyUg3gWmakvYHChLY
         LHNIlqEq9ofQONeyWY5z2Oi2SnhNxQiHB4w2xoUorV3S2ZUalVWE40coTAMeEMoNs8YB
         0P0Uv4pi3ZkweGugY1eEYoCZ8HbjrAdIUpYkgOH2CNRA+FgstEk4CwT9t1wuWP/gdiPL
         QTYw==
X-Forwarded-Encrypted: i=1; AKwUvBwX/XXUO+rM46pd6OQ8/9rqiBd63l2wbhTdNoTgvVr9bNTqGmgSJE8Vw+HynmchKuVijaup9x2Dog==@kvack.org
X-Gm-Message-State: AFuF++mLxgg/MZt0FcOa3Vy1q342WfaSpA0egNSB8udpsIy/HE7FSvXf
	yk6AcCMCeAuMLkN/pOWY/GPkov4EMQCmgt+O+7NmV3N3vbj+UaAySwnbS6PU/SfkBC5e0YjMcW+
	ZH3xMQNdSroneaGceRj9zcQrDKLdDBH8=
X-Gm-Gg: AYBFou3iGmVpdcdmYrDcNRPNFUxHAjTkqiuMp/iCchCDlA4liiMjESAl9fdJBTgIPEE
	m+HmhGPP19AQMKBP6iBCS4UATDE6lNXMm365KwsH+rym69695FB0L+oEQfNel5eGjnXulTMWfcc
	20TftnDVUhUfCT9LOHHnWE6O9qTwR+0BuBlScuQVY1BQf3XNZbIL737DFQhSgtA09JD6ENp3R37
	hQiTcKe65UqxqJRLjFrZwYDr7JZdK+z3egravatSg+dLjlHxJ5j5+HeIIdzqw0eZXI9dakIx0ED
	GgvRsKuWm1kBEj84pL9CVvfwWwuKLZERI2zxUOkCRloRrMz1NwyOe57mX7j2iWC+QuyOesOjNw3
	cPrm4ZEu4Wjo=
X-Received: by 2002:a05:600c:1f8b:b0:49d:797:83bf with SMTP id
 5b1f17b1804b1-49d07978531mr204052715e9.21.1788892025845; Tue, 08 Sep 2026
 11:27:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260825135209.3135169-1-alex@ghiti.fr> <20260825135209.3135169-2-alex@ghiti.fr>
In-Reply-To: <20260825135209.3135169-2-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 8 Sep 2026 11:26:54 -0700
X-Gm-Features: AcwNN1XWAUvG-23xtpJbnb_GPrsgTTZbDcBPWqZeCmut1kbtZYtODFU3-vLodh8
Message-ID: <CAKEwX=M0o3SRiX1bQmqQq3RMAUL7pAskjRgtmFXw5kWyu8Uerw@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mm: swap: move LRU insertion out of the swap cache allocator
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CB21240008
X-Stat-Signature: wj79et53yk6x4786y5ym7x1hwmtrmiwo
X-Rspam-User: 
X-HE-Tag: 1788892027-953383
X-HE-Meta: U2FsdGVkX19tzRFURw4N6q5oYiHy3etN/Z4YnXZ74cZKxNHKoq4ztBf6Wej0wIOOA7a5vwRPRSHGmW/+0a9Kzhsgh2uc5PEqihuLy536R82Xyq2z4Tz2KEWvBLCBPcNq6IQD53h1U43n61PFNOI0uFKdz7vzk6WqMSEtWwS6B0oIy7rFz1LQIqO9/9m/SwIS64DRRRqSMsam9o3qOMlcZVQOX0iW/ZdL7+iO54rtPD1aF2mRNs2mFWal/5IYpeD6Hxy7CYsl04wxga18Qnez3tvcO6re06rmEn0YOZT/tfsmIN/eZCUxK5zGsYSMxhaNof8dRozqxcPvePG47rbLDEuOscwSYiO48e5O7AdSQM+xyYklCNA+K/0hzkKNBDehNIU/JkpJUlRksTkFU+YCXj8CtOi8OwBeyO4or/Wisyob6uMZKq7z7SUdseCQXIWoSqlfqfkM4u4bcOyTo/Au+D+5rdE0jY3/2QBirc37mGQSmBHDUxPOyjQBvAFvsx3DJ2dyxMopTuXXV+MitZ4aj/xTl993MTsaBGy3Dm5oqpfqXp/bxc+RYkg23Eadk4XU+BpirlUC2FOfiYsGBT5j4YHWGRIGgX/qxYND7/cELqILknLjHiZpaakNKEf+PxUqvOcLoxI/fl6D+9Oh2m7nVvbI1FcdzIkaO7Q3JiGfimOll157mYqns9SFbG+VYs5QQmQgf/kIiXgAegZylK4XYQml7T31TPAb5WFvkOdsxJ3de+1ijFMCU9q1jzwnBgeIkRRKBXxr+LUwt+Z1zTNDPVWd4InWn+HLZPL+ci+qOKJqD8DvZky3E7tvwJjDP2HNN1wujcnJAZOEi5VACRyzdR/8ajxNaot39C5LXx5teFQFU52S1EO1T4MRIyOhmaEPME30WjSUmhuSwK4DjXIzfy/rrzGTxPx1Bqd5w6zVRbbxplHOm2RNqfYrWEczC+ZtqIZbjNc5ha58ohMhrdg
 AdaV6/gK
 bHXjRHFN0jUvbRD5m/CG3Tf2H131vZYd/qnQ0XOU5xV3JeVz1PemCwG1Ul4vuNvE92rXumIe/c+51ZqpxXN9BPkrcmbvWv2ljUKvkL7cZt049GF7aa5cPqf8Qtbtw4DRNCJuUW0JCkK8Y8O1cQZ1xLU8OoY/5qLlJKe/HcEp6jXWDaxVpLt0eHsOaJiYz55Co+BaXmmJAvwXNc3Lo2oeqfR/TxA02AJd7O2GqSY7Y03EYKug91Y90emdzT0K3gVf+tKsz+IkQ120fLpLBYXgerWhcOMGNChg4+owOh8NF1BldsEaHAXFGpSIYrwYuKa7ydPSS76V/97YB4LVuR++BQQbtjgF51WvGYnFqhnupiE4Fw0lO6SX9Fpwv1oqdR2N9LISQO1ZjrZWNbMc3TvueE/d8ZP+oghsRvSfTP60boL/5j/y3gvklN0oL7KLC4HcG/0m443xUbO8NF6sCUlUp4M6ByI5K+O43tthPntlc5vFuwznG/i450bDfKqPWF26VJgy5qrrEL1YBrQr3MzCONaEJZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 6:53=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> zswap writeback wants a swap cache folio it can free directly once
> writeback completes, i.e. one that is not on the LRU (folio_add_lru()
> stages the folio in a per-CPU batch that holds a reference until it is
> drained, which keeps remove_mapping() from freeing the folio on
> synchronous devices, and likely on asynchronous ones too).
>
> So defer the LRU addition to the callers of __swap_cache_alloc_folio(),
> no functional change intended.
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

LGTM.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

