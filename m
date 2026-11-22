Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A530D606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 07:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=GIWk3jr5
Received: by kanga.kvack.org (Postfix)
	id CD50B6B05B3; Sun, 22 Nov 2026 02:08:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB3A6B05B4; Sun, 22 Nov 2026 02:08:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1126B05B5; Sun, 22 Nov 2026 02:08:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DE2A6B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:08:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1DC76120663
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:08:58 +0000 (UTC)
X-FDA: 85461877956.20.820AB7B
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2C9F440002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:08:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GIWk3jr5;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795331336;
	b=VITi+BF904UdvQQ90k/KzIG0GkkdewTgPsVs4WOd/jIsSC4o+qxrjkXBY6S9x4spJtIX8Y
	q1mgtKbXstI3RntUp+okQwYfCkGA7LAK88qMme808yCb0H1HieMBnnuJqJo3HjF4zuEMLA
	DfeEQEIp9AV9jgAwrqNSZ/a8p5Q647Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795331336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a99BfP2kEbISB20mRXBJCu27gZNr5+UqvH+W0E0W/KU=;
	b=RCS35ybZSm7iCYtDQj0BIIVLUn7zWBoCzjJqKZ76qrtkuihblZoZVs+6Aqp9VBYix5XmbN
	vTCj+fFM4l4RLVs8R8V3RABDgU622iQZDTFRZ2N0q2mCVhpwQsRxxDGS7uDNv6k0n4tUsy
	Wa1cMJkzZxQUl5+3vqHKmxHX+TGe4C8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GIWk3jr5;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-92119da3d37so22683736d6.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 23:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795331335; x=1795936135; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=a99BfP2kEbISB20mRXBJCu27gZNr5+UqvH+W0E0W/KU=;
        b=GIWk3jr5CFb1X5sEcOkNlr9bB5MxAmZzZYxPHbsiIixT/YjQtDzkqQPU3qs8HEeU5P
         MUwzq5edXfLr/5qVsJAKXCu3OQXRfVwRXwvTjTqpDakGbdHweUdFB2FNA3QAnustSUYB
         UPRbhAMUmIE02SjJ9Rgb4lyjUXTmFYIIK6YbC3xNIeOv2YcPJeZNdgmxMR69978cjjN/
         eF6i3BYK8M5CkbawZXoytK27aAaCHRF41aFTZYzzwRb+VWkiPFKp15z1O1vd+ejuZcYh
         +1SiUqXQbYGFUQP9TndwFSBt66CrDSdMffEt7tyNpSu0XOya1olBzW3JdFL4BzFnYkIj
         gr6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795331335; x=1795936135;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a99BfP2kEbISB20mRXBJCu27gZNr5+UqvH+W0E0W/KU=;
        b=qSt/uI/OVF5TxAE21GyDyzfFgX1ye3EBkzGS0Cu/i4P2Ncp/vMatxFaOb2IO/Na28v
         ISWZJe9DcIUCGvHWzWHr6HjJR3l87aThrULKmQ/DBbJwTZpOJc6z8U6sBJ9YmPKkEEkB
         hrTjY2B+5jKZc8BD3IGrN8Gk+S4xqwHJAEw6+7esuIrt0I8Qt7lPrduVYnY23yrfpI4O
         7eXkK0smwAQr7pU5HijcRjdooxenQq3lX2IKv2ycXlGJ1OHwfkSP4uVSWNxonIDa0Muw
         hfCnKRGaDOelDA8PoWaJT8Q6S1rR1nAQSPhkIqMFgFPD2bMDTJhhp8rgnUeU1q2whz7s
         ti9A==
X-Forwarded-Encrypted: i=1; AL+hErFE2+TX9A8ELT4uvgEbxdLxc4yQtFT/IMg6nRTar2kBqltdpORqf+owzsONHr70TPQ1wDWaB9Bsmg==@kvack.org
X-Gm-Message-State: APuU4Z93bzTuHgf171HhmEdIHfxWLMYXyBUWHMRFTs5QlLH9E6yQRg1u
	MNPdjdwyAteNe8nArx7N4m5s0FhUxjTY2I2s7ISourMNYXS7A/8mSjBDIbQAF4PWJVo=
X-Gm-Gg: AZFdTZfJcluGCccxguQyNtMtIPd8zmV68JY2fA10DjtTLgyzioZgo4M9gRctYhN4DLd
	38gGu5BIdaa4Poc61bnqYNlaVuMyThdooGHqPJZwMrZu9m/+uWF4b0abJH11UZwSVSOvL5nxFms
	iuX3n4rEN2X/ULdxgkO8hq1OcBnH1N5Z65WVy3XyK5EOopEWqa7j8rtW6WMunm33449uAef/AYo
	Obsuz30PK0/zQ86SWLXEsm33lfqbniysWiwJ/MjUYTdxZUODzYV5id4YxR8Y3W1M07nDnz7OlVt
	oXveEf/ADcIQLsPJcyOAbXUSDdEuahs6VdLfckXlmcDEvxXgDhEPSY+ypqNf75910chMfVVPsvn
	cv1k4WkU9H96VinfkQ59Ot/Jrdjrzv407hMD+zNhxgVV2Q9y2A6B2IimYta1jj8HiB8QL6S15Nk
	pth3vT2hqTFUF8FmiK/r0iL4CQ1hKnlpMFPwLJ59U6Gq5Fu3VtA0o00LS3L3HIyJCMzJgJ1/m7a
	UFPPxiZwrVajhlfR76GPBkXkewWTMmte7EXm9MElbN6XNlBM517A1SoZP/rp8eKaRtNt1mDRF0a
	T1zfkTHEen1Fk/s6ikEWEgASj+5VYudCNL/e0O/zbGhgYMEK5hX1uV+PTa4vL6Kd3j1ooZgpqTf
	aItY/ZRk=
X-Received: by 2002:a05:622a:138d:b0:536:702c:f8e4 with SMTP id d75a77b69052e-55d76a75253mr152041481cf.49.1795331335422;
        Sat, 21 Nov 2026 23:08:55 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7888fb27sm66124541cf.25.2026.11.21.23.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 23:08:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] [v3] mm/mempolicy: replace copy_nodes_to_user()
 interface with put_nodes()
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Arnd Bergmann <arnd@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
 larips <larips950@gmail.com>, stable@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
In-Reply-To: <20261120185248.823415-2-arnd@kernel.org>
References: <20261120185248.823415-1-arnd@kernel.org>
 <20261120185248.823415-2-arnd@kernel.org>
Date: Sun, 22 Nov 2026 02:08:54 -0500
Message-Id: <179533133443.412063.14905382167508572303.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: qie88a1mxh49maykcwk6qwmi1bmrmygu
X-Rspam-User:
X-Rspamd-Queue-Id: 2C9F440002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795331336-654893
X-HE-Meta: U2FsdGVkX1/oFMLdimmASv4noidnV9w0cYu6IN/z8mX+Tx0LqmCMMdXChwc2xofVb/m4cjV9XQ4R5Y/6rntg5MG8Wr9+zqlQvGLJQQREk9yLE/dJMO6TO8OVLVmW1FmPK0fugLwyp1wfl4W3KCRYOaRZez3RRJxLStcZw/zx1a7GpwCp/vb2cXrt8FDq3DUtNFk9EyPu63k9mXku92fnjDic1k9Gr/AjH6pkuVuz17D5Nc4Wh22fjH6Ki2404Jc10eLsZWdy166kKihNlZMwtFqJLaYtwMHKdoRpysRxnKIIOLgTCeQbhG9rvQm2kvf15TgBEy2WrX88zleo0QZSF1i+QzzVXevArw4fCBfv3hy5RuSeoUlzJQsEH8rwHVwzdahbwWmt5M9Zwvy8YUhxG5TNPydrBmjIbPpc4wX6U2imHmLJLkGpeKhi9zAe0rfTG8SAwdiMVCq739R5bWbt1c4qxJK5Y4kqos/KvefP0qV9+VVaY5NvDPE6pQ/Wxgap9WdBP0RQnsZhNr1uAiYnjQm7PiEq6/b5fLVYrUpwyMi6SlaqBPFY0GPLScQIDrzE5cHJAgULHWttJ6BzCswv5Rggctkj1MrXZunCv8eajhETQxl3hreUjB7JOxcCksvAEnMGvL23svIvoe1cju1PO5OV08MLMgYv8PZEUaU5r9GnhuzxoSk19o+CLLfyMvU6mHC/gS0m2yrwZEzThsZw5fRGfmRJXQtPmRlUiBpjyL7muyxuYAbD/WQsJ5iGOXQD5wsVZXcU2AmUTi5XIERj27oUnV/RDhdFDzYjrs0SAMBD+fkX6sHUTvUr/IWYox0fIYxdDojqs1795lRU2SWbhs91LUHWGzknL8vPkRGjTNlWdvvhaOLVQLYdTfqrm9Bv7HlkhZ+PkmjM9b4vpzIExg/rjhIpfFuVSE8wA93lg2Cdsx735+oIU89u2w4Ato3mudhzYSDqf5azNVDvU4f
 elvB2u/E
 tFBtosARpV2kFTX+U3nbI0H+TwoIYPCqJWXhmnK/QniDHt2nnbkUdYVxYZpJJV6sEbHaBYgIA3gvbrm9tKn/nB20IM6SsvImAwZmff3VVinGZxoAyjbdmZRD1evl8An6jIdlHF4v2R7BVEUi4wS1c7FY3pr1f/f2s4vrypfsUzi0ePjEtbJYgbVStwilrRnyci0D++2KTfKtVnhw63+66dH3DkSI8SFax6C2cVUA2of+1tC/zm3P+eGPW6QXS4cX7zenZ4p7BWPsr5yk0vyEjIug+h2s+C1WmuXBVWkyhIDqEnVxCumh6YvOd31LVH2FUovjMUIiJyfW9CDm1Qna5QJ9Ca74Dttc8kN/ssodV+ayWXG3gJta8P1BdKccB8+gcUqOlIWoHwB//nY267cypoW5D6UD6oqZ9WsUy4/F1ZBWlHiXNyGarkWC8cV/CkU5nP8eTCI1vBibzCGe9/yyRPe6A6rMMsjEnuUWgxRO/iWfYcT6j9KlYSVkMsmYbdDm8l4HF0Qz6mgnw9NqOMndXb9R/RWgQylKJe4GEAuM6eusbpuFNzNarrO+DpTPLI1cxJ/3UzasKGyTsFvsDiFaiFetEWONIsLJs+ccJBjaz9mw52zZrnGnfet1kc2E9/8Bk1wRPLaWcWNd9AuI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-20 19:52 +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The get_nodes() function handles copying node masks from userspace,
> while copy_nodes_to_user() copies the same masks to userspace, but
> with a different argument order and slightly different meaning of the
> same variables.
> 
> To make that less confusing, change copy_nodes_to_user() to look more
> like get_nodes(), using similar name and arguments as well as adjusting
> the maxnode value once, and restructure it for readability.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


