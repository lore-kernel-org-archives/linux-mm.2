Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B31F6C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00256B00AD; Tue, 22 Sep 2026 00:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0E26B00AE; Tue, 22 Sep 2026 00:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89FDE6B00AF; Tue, 22 Sep 2026 00:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 665A46B00AD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:15:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2FC78039E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:15:32 +0000 (UTC)
X-FDA: 85240084104.23.134A72C
Received: from mail-pz2-f27.google.com (mail-pz2-f27.google.com [74.125.228.27])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0A0D34000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:15:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RzoBei4D;
	spf=pass (imf27.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.27 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790050531;
	b=IjN8+rw0rcH8l/+KW4Y6dtvXDm6r775QMiNwvSCEVgKoFylV4Rfky4sRgpycbfbl2fdilM
	unv4NHuS7Ls94zpk63dgNqzSRlUUo0fXI6fc0sXOqDRrmpUU2Nfl+fMVyaZpLhCCS6ag90
	5f5jOA8z0pMgLd5ldAV2OUPMnPpLzM8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RzoBei4D;
	spf=pass (imf27.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.27 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790050531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqDv7pHlkC+KFYmyHHCyZJU3taMvXTuZA5VzDL+HOrw=;
	b=FL4Qvbts1k47WFxup4/nuekCmHWXJxVnPfZAK2vUDhhfWsFYjI74093tLPTZedEwT1+qoz
	aytkr8y61VRlH1/VmooL++7k6fR2QZU8v36WKDOzEVKRI4lEoVMxtQC8QgOR6wXYDq6REb
	6+adICwshE/v0f2mdrQawZbq9frgmTY=
Received: by mail-pz2-f27.google.com with SMTP id 41be03b00d2f7-cc1cea50dc3so2659502a12.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790050530; x=1790655330; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eqDv7pHlkC+KFYmyHHCyZJU3taMvXTuZA5VzDL+HOrw=;
        b=RzoBei4DoUYmeY0UTSZ4JEdX54lQ8yrGxzP5zqfJi8cDm5X4fAFepuFQnzVNngLA5e
         ms4/55Yaep5cdvAmSivyqdLvQ52sOdcw4BYbqrbsPetE8Ac1JvCyfxUnv9pmiSY27IQv
         KNzCVyf0j3NknCW1Z9hvXDFe07V6URqADtaeBb3zjtyk8vr6KZDbcAQfuOiStSHQNMrw
         ZnMi3ptLS3AXlfzQBF2DP5huBLcYFxLvXpf8hqI2LJ3DNnY7JNN31OQ3NDXc7wOSOwaL
         4b/iSA8SElTivY0CY5gHtV2n2zfi+oiet3n9EX2LP6p5moKVZOaz57nH+Sabntd0t+e3
         y+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790050530; x=1790655330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eqDv7pHlkC+KFYmyHHCyZJU3taMvXTuZA5VzDL+HOrw=;
        b=pQihrrhW7aU4nqz8B6jVZyO3Pg6xbCD3kMKHN2HZAPLZFQCNNq08PoZtiLln+98AUi
         HbqSTcFWefGo3bYF0kQ2Sk7XGkRhp3Tq4DRljIygGYK8XR/Kv4k1F5Y/fbE0n460xOdg
         hF6MsFpoFzSkUbkrsDfVRXsCrvV9NWlzSWMKObe5ChkwsYPm2j7E6Q9clW6drzwdKBV3
         OV7Ha9/xQ3aj46RCsqXDHhehTy6L4sXue694fCL0DhQ27HoL8+8G+F7HpT3A2rt3lSzQ
         +7lx/jVI/sckC8LPEy6HylIa9wHTWQzBKeMlwRgwpSZQiqDMUI1r4rEcFTSwhNEEsL/N
         H2EA==
X-Forwarded-Encrypted: i=1; AKwUvBzgw/LtQTntSmIJ5rqxJneXhRQzmv8OWfINjhtzKnpnJrh17FApweK7SWsPJ8ioJrRUiM4sMj5FmQ==@kvack.org
X-Gm-Message-State: AFuF++mSXtfxBiOgS59e3KlziuvvJmeCoyY0WpMKPcMSN+iiLlSb4O8U
	T8yJ/Yi8mDMCIyUvDnVfja3MyEUrveqPDT4LtlHnm24xgSuM7mzCVcGM
X-Gm-Gg: AYBFou3d/m9ej56HUM3BdD3/eYakBQ3jBPFAxc04b5NPv8ZU3p/orjF467B11HP8Wby
	/Z6v+uE+H4KWT9WYYZVXzNhMN2HbgR6H75v5Vqq0/nFIDHBXbwGA6N5sYDLnVZnl9nU5HBsGPuq
	g2lRtuZUGyzcWl2zXjr/PxUJ9DH1UctbjyeqdAHdfaeADhTfOQFCFb5T4M3ontPGu+H8k/JN/9r
	BSfl0P5uRm41sY7P+F4pbs2zJ3L0i3HPyz2GjC0SiHh1EbfTu0zCVlEoVKQdvL+u11zLYeO7xXy
	4aJ/Yywu2/pns6ztsv+X5rm7JdUbTvHM+EAAg7xk2wXbFhLQAgp5gTw+IWc1l2MzvoLZw1el+Kv
	sZ/9gT9/ZGjEiZGl+/jVe2K1dxLE1WVHry8dY4lYRnHr2mNwlFckeYPkwbsNFxpdl8jB4a3z2Ei
	Y1YWPGhxfimNtIhN6RNk1ZyWlh92BNEYlBhTkjB53PAO5Ys2sC/2aluNqfg1z2KPosNwpQ9rp7h
	OC+8ZSYUGHFnrMG
X-Received: by 2002:a17:90b:384d:b0:39e:6c6a:4b67 with SMTP id 98e67ed59e1d1-39e6c6a5448mr11353516a91.49.1790050529698;
        Mon, 21 Sep 2026 21:15:29 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06e26e6a2sm887240a91.2.2026.09.21.21.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 21:15:29 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] mm: compaction: mTHP-friendly memory compaction
Date: Tue, 22 Sep 2026 12:15:22 +0800
Message-Id: <20260922041522.1824249-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aq1SrcniIRU-8f2W@gremlin>
References: <aq1SrcniIRU-8f2W@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A0D34000B
X-Stat-Signature: wrbjt1xh1s6m8gtwto8mk5hc5xzhqojh
X-HE-Tag: 1790050530-93018
X-HE-Meta: U2FsdGVkX19zwCPGOIQV9lwR0a+dW7RwyW+sWEwywgT9Fq55SNHhFLoWE2xYYXWVCwFivWdCDNn8q/yaPvQERME1CwFIJos/y82EBssb/wwRyRSoS02cQ6Pfdki8KzPXG2SmqtbsFRWHF9tXr9mBzICrjpcOlyHkm+6LjTYAs6cuGabOc+E7MgEsj2t1h+0Y/8XQHYer66EqhjVnYhxHrpaGJKB602uN8gukJlXHMZOT3T+S1+pML7ZVuhJDOJ/3zR2MrKd24lw0/Ux6+nuB9R7KSusvGddzE9dZ+2x+1SwSUqHlObNKEZ/UtcejbnbPjW4KvVs7TDdeoCDIaoyqeYSZJSJVY5Sw2Jb0DpL0YWq2u12MEkOgVKzPbmPkRF4EoeLacfsVsitg+o8cjD/J7WhelcVL/9zcRI0w0KHkhzHMktPMf+d7zRhcaTlHho6DDixIKCMmZf6Ob4BhsqOQvESieB1hDaWS38QIJs648ye6tYNEpq0LrU/jp3wsGRHpE2DgMuH1fmB8l8U26hV1DRbJxLBbWTg+EaG6wyT06PlpIRuxbMTYx8DqIJmk1jbs3j359q7YDAjtm1CrAIb12EzQS4TWi1MjhBqyQv1lxdjFzMecZgAH36i3QVItxl6EJNxkMKXB1Sd3K61pNhrt7V8SeKko3CVv2OVVz8Ikea4ZzxuereRdVhgdv3bnXUdVY8j6PGPl/VDHX3mwk0Mcf35tRAKDGjH2z60e7uan7jLBDwJU4htnSDu34yNKWv9PSHxomDC11Scf3W8KIlUaXMLlBnKqNKJsF4cwCAkXB5CBmADFyI0mHNKU0R0TMHsPzfKC6RAXt+87pTkhQpuyvhHWsO61zr8gyZWRXC5iCcudXWaJnodnBGXGVuiHQMQ8LdTf/dasAAKu4brhTwNwM0nhq33OjxHMKf+JI+dgBNQFUCmZIB5W/SPayymR17e24M2PK8tewhWEMCQ10DP
 fXSoZgwo
 Bai2OB+Y1mFAAQpIp9qtIuls4pWGtv38720JRx4y6CscKeXode0kj++X4Lnt7wDTYITDeo5bLNGDesXB4+SUH9JANeMkUCzeXQqZDyVUM84PAO2YZi9wOYJf7ZDeWEvM1sYcwwOgY2b+tcKE/bRTrYHt6Bmwy82AEVy0vpSKg0HAxK52ke/b7VHw7yHlQNUbpWtULxy+omvt9TWs2hNzWuonRxbbM7KKylYGkyJs3SrK6SDSEMIkav/Bju7rxc+x8oibEXGYmM5b7eai6F5BrJnVVCRrVHxVad+ct44xuMNNKMnOsOZDioaN3H8SB5oLrGa9c1u2FYdn7vcGEG89mTD4r7lYJS9FfBxXN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Thanks for the note. Let me clarify the background of this series, both
regarding the AI-assistance question and regarding the scope of the change.

This work started as part of our exploration of 16KB mTHP for the Android
scenario. The overall direction of making compaction lighter-weight and
mTHP-aware came from offline discussions with David, who suggested this
lightweight-compaction angle for small mTHP orders. So the size and scope
of the series is not me diving in unguided as a newcomer: it follows his
directional guidance. Barry then provided reviews and change suggestions
throughout the iterations.

On the AI-assistance side:

- All the code was written by me, by hand. I understand each change and
  take full responsibility for the patches.

- The cover letter and some commit messages were polished with an LLM
  after I wrote the initial drafts (to smooth the English). The technical
  content, the design (jointly with Barry), and the analysis are mine.

Please let me know whether an Assisted-by: LLM tag is expected for the
cover / commit-message polishing; I'm happy to add it in v2 if that's the
convention.

Bo

