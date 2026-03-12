Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C0421067040
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 15:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 663076B0089; Thu, 12 Mar 2026 11:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F02C6B008A; Thu, 12 Mar 2026 11:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F34D6B008C; Thu, 12 Mar 2026 11:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4BF6B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:05:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED9BCC16F1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:05:10 +0000 (UTC)
X-FDA: 84537733980.28.9EF058C
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4B81B140016
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:05:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CLi5rw/a";
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773327909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2aFHUSGg5NaIDd3/YxMv/LxE90w9nNW8znYb5WStZ4=;
	b=vgrt07McyyC5M3YSkUYZJMM5PZ5zPc3QMYxzWC2urXc6gg/1ztfv5YcGvu9c8pllpxpy4h
	k3J237iykNufbwB+dH7c9iLSe6RYVdPa0nrX2M1STY8gomzaquyN+Gy94RPDeJVc6hOIdH
	JoYrvjhrQEhiZ1jKcPbnkx9rSaz3nTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773327909; a=rsa-sha256;
	cv=none;
	b=iHR+lQcbTxnWlIPWp/4aHhXdg7LHci3HD4VYIb8rolgrZkQDGTp4RwBAGf8ARvMQN+1Ccm
	F5qCY109QRn/teN/kIQqf3C6dXCzJXfZVqRQOG0iXzvdsE01KfdJ6g+WcFpu2eEjjyDC80
	kkJctAWFUzCIrQm2IE0KjjomJHBH/V0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CLi5rw/a";
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-46701f2077cso1825852b6e.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773327908; x=1773932708; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+2aFHUSGg5NaIDd3/YxMv/LxE90w9nNW8znYb5WStZ4=;
        b=CLi5rw/a1kL0It51VVgB15sQPa7lmzSL+7/ks37cvfyFozzO1sVIHlD+BYdN7vDeVF
         QRjCd41lFxOGCKbTqbJCw4VgFdehJJq8cSXHq2NCtyvpApxq9s90QiDXM9Gdo8iYOnpm
         gF0tkMJbqMykzkp66OjWYgrUIOd8RdE/Oh7UIS75/epot1LOTAoA/CdHB3TJUesJT3IT
         gV2MRYTa9+B8x1EtGq3KUTMjgLDv1aP6UgWSENZSWzldMghkv6f6kq/feK1i+nUVszNn
         lIzr+6pLi5tnTBTTSSGqXnDfjbCW1ftnkBm/SkkOCNu6NSi3NvpespE9n8J7NrsfRlB5
         vq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773327908; x=1773932708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+2aFHUSGg5NaIDd3/YxMv/LxE90w9nNW8znYb5WStZ4=;
        b=puBZ44wx2tRWiw64C4YsNeRyLzvW20tTPHWVGOJOromhtNroDfAcM/xVJgx5LlFbvE
         hHaxJaol5BcTpZX94fSUpeDlNEaCoskTWTUUNiO/kFTkFmDlczXEQC2yQf5P+f+hCt2s
         44eatSOeip6ZDoKerJDskeM43N7Nf58tIaKtN43+ZjVVDJvxcGJT3cACXXVJqZAB5Fiz
         SHypnzAnFCeiVAfZCQ2WsnWvblrg/aahQiqDsvy/UY2MSttJ46iX39Zu4K9oIFSGcQUk
         bJayrYLHlS1RkkChrB6B3kBh1DX4vq1dEDb8Ru1qv1Gcz4C6dYcP3z0HnuT/T0J0/dvJ
         bH7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUJ1j95tKal2g1eW2kFhR+PfTxUQkOEs1cCdSst9yMVN37xwpMP1aUPjT5mkM5ktt+0oifDUG5LIw==@kvack.org
X-Gm-Message-State: AOJu0Yz5KvgI7N63vWLVW0KsJFAfLKGbv0N1Bx48hyw0PkR3B7YTXFE5
	XlO876yYIFUQw1uWJ9awRi6rnOx7p/UolxW5Ds/yqX5L1iDvdoADsln1
X-Gm-Gg: ATEYQzy7ABjGQAiDFYCu11523Vz2Q92NPNocwTiymUA6bCLmvpyQo8aa/f+ut2xccLO
	T2gfu4mfwAVs9HDAZ6GrhzdPObRtyZAGlrVwPCvsWpVpSe8yNFNfPkQFo20KETzUY122zlOAP5X
	b6YRVniRtf2FXhyz6mKr2wkLk7GrGC7gI+AsIR4oVE3scYWkxJeym07OobWKmt45TiRLhC7Bs5G
	nh4hoRvZ1TaXnV94yMnsOa3D66Mls/5oJ4J1HJhG/lNG0pWSuSR0w/5s3+W+SQdWU3piL0ym0b6
	8EHpxE8feSfC602jvRWLP8EVVOEVcQuPpOk6b6eCcRl//sgIt/33eyKg8vEhcnTkz+riVmguPGd
	xXS/v0Mgo30vqck8sxjPb23yVK9rGzpQ7C8Zeu7wyGm55WlzI7oer4HTnz5HZog3P/q5VSutc26
	MGv2RyB11Jvz2ix3rGV+NklQ==
X-Received: by 2002:a05:6808:4f1f:b0:45e:fd68:3de7 with SMTP id 5614622812f47-467431d1f7dmr1968478b6e.24.1773327908252;
        Thu, 12 Mar 2026 08:05:08 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467342ef6fesm3095232b6e.14.2026.03.12.08.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 08:05:07 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: YeeLi <seven.yi.lee@gmail.com>,
	akpm@linux-foundation.org,
	david@kernel.org,
	dan.j.williams@intel.com,
	ying.huang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jonathan.Cameron@huawei.com,
	linux-cxl@vger.kernel.org,
	dave.jiang@intel.com,
	gourry@gourry.net
Subject: Re: [PATCH] mm/mempolicy: add sysfs interface to override NUMA node bandwidth
Date: Thu, 12 Mar 2026 08:05:03 -0700
Message-ID: <20260312150505.1502645-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260312150022.1373486-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4B81B140016
X-Stat-Signature: w1xat5smnsxgodi6hunmp1tgjc3p8j4z
X-HE-Tag: 1773327909-773258
X-HE-Meta: U2FsdGVkX1+Jp94B5eq3i4X+RqDMBrc91TwMxSUFAqUqxIQddD9Y+emt0f7WEWCHrQDJPAKmPUdPiQK17+q++W+xDhCnQr2u1hSAaFhXysgRF2i+mCL3dq1STt5tEwBZxiXFpkEflbTKtyhl/EvcKCXIEFPF7G1EI0RLY+U66/xSIsldcRYz5xLi22/Wx9Pcy6HIOQffcSfHOMZhWXMkDk1dVYDjtFwsVuao7flJzIKQ/N01/guskD9D9ILCCTnrjjdVeyfoJhi4ZzXeDbAmay+JeWWyOyW+EoEI7UFBKfkeokm7B3aFWKPt5HYPVpV0VeBsX5hWTkrhCjB0CRKMKmfmklIXajADKtHHcZdTwVva5kNpzgOsfB3vv1siiKJT0tKnZTdmEKOx9HfxVShV2yFxhtw8RWMDa3GwOiE/KACmpoFKtC2Ro2tJq+C9lBX8D613kU2B3mmU7KkvQ2lp2ea7r21nLsl66i/qNzFRx4PxHE05e8XeAxVkwie3/1qQYg1dODFXLMZLF8n9YlZB1XbXMXT2h0TGHPR4Uhhlcgcwr6jxbVArWMjs9xUnGkMu3pwKFuhezUkuaxC6TSvR6F7XnKm3yVLm+ToO2RaIZkO+alHe51TKaTG2DoM4Tes7KaGTJQ1g7v9p0XYL4Zep/pQNrxOVo7mRaA+PigJH+jDWhnqUAml4dhBrYo338YtS77bFMPGTiwOHVp5uxrMfRqPIelBzJWjEsh2qxEawc1Sm1jYMDDbackyBOd+fw78JjfBzr6Fx5omGscJV+JCYLQrvOA/IRPTNhWpJNAxh70Iypns4dHWTf0ioeimYJuKRJkyNykR4wpQDbbhs6DBvlsbIewT9oU2yK/bMbGgdO/e/jiIMB7/NodLWC3tvso6Xqny4GB5VrTOA7yPmNaXsb9e/48J7ahA73ZULLsM8MQ644aFdkJtsKd+h7yMDCj8xjWu2lDXMx6XhaOiOhxW
 lEMwkLZk
 PKlmfxLIBTTBcheZ8HSV3RBDB7/kiSkwmN90MbbPGEApCsdHSDdTqBB6G4fICyPuNLwgnoLd2Tb9X4bwmEUVcsOEj2sKLrOZFSqHk3GmjdsuKRBSb8UddAiXME7J5LXHO2dtoGWzjTZAKHvggBWsG5jkILDYi+RdBUmoz4D3wYIfo9/I37FqAAHK/dXl1K/bN1YGwBf1PWvrorzJ6cn6V3dVY/pejLX4NqSYskBgUILCrJZJXpGPVPIT/cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 08:00:21 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Thu, 12 Mar 2026 17:12:07 +0800 YeeLi <seven.yi.lee@gmail.com> wrote:

Cc-ing Gregory's REAL address, this time... sorry for the noise!

