Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B1C606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wx8dB1kn
Received: by kanga.kvack.org (Postfix)
	id 9FD006B00EF; Mon,  9 Nov 2026 13:15:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD246B05B0; Mon,  9 Nov 2026 13:15:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89EB36B05B1; Mon,  9 Nov 2026 13:15:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 689CA6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:15:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB130807B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:15:23 +0000 (UTC)
X-FDA: 85416382926.08.EB85450
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1A92C180004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:15:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wx8dB1kn;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248122;
	b=sCY0xSTggKrvYy9e/hrpLrzIUuZMEXMJ0oTAq1WUdE3FtESKgA5RgeoHcECbP8w8aL043p
	keiOFTLomdjf/SfvBPgzSUZ6RYRIlY8RductQPDju1X14q/qVuGUZpDtqrSBld1ZXnVE9E
	NoSsLNrcP7RsRyOvwFyqjI6CdCkKlMA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wx8dB1kn;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DvhcgTZcrkTnH28Ju08E5VEVg7jwb2jxxTwOX5xkft0=;
	b=ku6xNMmBzdmF2Tg6kVJyis3eMBFxBNhYhuPYcFPgh55fQyVSCSt0RaS3n+LPAIFlFC+Ptr
	TW6DqKaqUYIPcDFsOFLwm+OHg/ywEuSi9+K5qZkgQpuZ+4zZyHpf0tKMzdm9LMWtHepl6T
	dT8vzOl4eUowqU6SGhRAgxJ/Bw7R774=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C810612EA;
	Mon,  9 Nov 2026 18:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A240F1F0089F;
	Mon,  9 Nov 2026 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794248121;
	bh=DvhcgTZcrkTnH28Ju08E5VEVg7jwb2jxxTwOX5xkft0=;
	h=Date:From:To:Cc:Subject;
	b=Wx8dB1knEZr4NSoFk8tLdva1Npsbq67GIgf+PEylNq8OvIpLP+eqNopEanaE+iREC
	 6XEt41Hh74eonyySwlyLLMW7WgsNvrf+3QfFrrbx8a+jwFzQgPLnl6igUvEGlrPZck
	 y70kBD5InBgfUagE4OoNHLkXn1aT4Sn+7sKpYMyY/jlDoBmDZ2VG1EBorS4itvFz6J
	 G05s2IaTZ3jGI1wq5H20aiWRSvTzUIMQ0nL14q0duCVfNv6maqlr99AlxdnGPkY59a
	 VApimUnjhTaJzEZJZOBdxh51gHYZWvfoMPrUteeduJ9hvZMVkDaCEhV6kblBUbyhMC
	 vbE5rAX7U42vg==
Message-ID: <a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org>
Date: Mon, 9 Nov 2026 19:15:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: MM: Firefighting mode
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qdgnhf6oux65grs53jpby8sideghgro3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A92C180004
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794248121-248709
X-HE-Meta: U2FsdGVkX198CMga8IpKvZh5QO+a7SBVdLVrUA+fsr7XcScAZFQ7C3ZJWr2C0nRgCqK1zwqEPDWfAnTLeBwtAkB0gXf2rZ687n446IIvInFGWV11KymsdmkoX6/+OvqJ5GeAM1otaa+vfLpuaZj2Y0r5Ltgc4LxXegOVqCbWjtN6rbZPr8ftHPJ0EO/tPfYN6PRzJLkbFE1jJvjtEC3vN51rxonHYBSu/ViNI78SXuohjoJgpi6Bz44grmRAKvddGVqVirerXNLNUtVDESbjGznoRAMB/xqf8KwYl175WefTesvymPQ7ExvZdIoVtjjOU65Gw4+s6FtwZC9Z8fvqXW7ocl+qhOERs3XLGaczLdCBdefeImor/mfQICge8PFHS09nvBQyC1auKcd9CrC/IeKyVLgouNC5d00+4wEQczwhRi51ZFm1znDuDuYoTF4BKDn4zMqdz49eq4hBzHh9otVcz9sXVfnPnmZSC+j6TGnog+yxVE676aVOXgGR/PcxOdCq7xqdLBX323nuOikjv3w/SIPyQdLgia/70PqYiWSTp9ItyvEbocaIpYqDY7QNxJnkXtGgozQIz5QcwFHIA/NoKQ75iNcO3BO43XFIyLsD7pdz1LMMtiTRK5rj7reEasRXWjeHiitYYNmmhGuFFT/0yYZ3Pz1UhwSIugQ38qEVLVcbIGwfWLGNUWyuL2sil3kZPLK/Ts8SqwIksZ2LRFn8QgTKVxsjRreCllNy/nqrrWKoiMCwPjvGlWup9ViTfDB9ZsQaCR3BHU9aWfxlYvUtuaEvGNv65MGgUhzGhLbrDwp6uoG/duGLm3H/TrhFooRI1XGzUwQMxrvQf/fFoUdexxLYkxz1Dx4s3o1q4Zjtg6jvbAX8vo9jK1gg9qnP4IlOkDEpJNlZvXlwqHfqg/Oyqrx2cECfDdObFNirbuq95YuwM5wKCsEf/qczR+Vi6GDEMj16pGIm1XpzNPX
 1wVWcqy8
 qJaRgzBzo2batnDVIuOpgHeM3VRJYbNeR374ALG5DADS79Zyt9ZwPnN1YqTt7XkhBydsG63JJwGUXXOL7bFT5FQDTsnHxQ4xZuZlLBMxBX3swUw9bewK47Bza9z8rLcuURSBge+euFkj3WcaUjtA8e+MXBm/vw1A3fuAuep003yf5aZ4hfK3bGXKnMiKedMV+VjUXvI76KDdIDxCcpMMOL1VsC319W2ZJZxrjugFXJoIjIr5lJJfXq+eZOoyqTGqJesFTjh8SEBpSdI4WkclgZ0RRDRw3WIvghhvnAhtF9hk4VWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

  "Your message is important to us, please continue to hold. An MM expert will
   be with you as soon as possible."

I wanted to send this out last week, but somehow didn't manage to do it even
after being reminded by Lorenzo (thanks!) :)

If you haven't noticed, the MM team is busy right now either fixing bugs or
reviewing these fixes.

Or fixing bugs we found while reviewing fixes.

Or reviewing fixes for bugs we found while reviewing fixes.

Or ...

Anyhow, our focus this cycle in MM is clearly on bugfixes of different urgency,
and I'd like to thank all of our MM community members for helping out with
fixing bugs or reviewing fixes!

That doesn't mean that we should stop any other development. In particular, I
want us to continue making progress on work we started in the last cycle.

Removing code or nice (easy-to-review) cleanups are always appreciated.

But be aware that we only have limited capacity for big, very complicated, or
controversial things that need a lot of attention from MM maintainers and
reviewers. In particular if it is low priority.

So, some stuff will have to wait ... longer than usual.

So if you feel ignored, it's just the MM team being busy fighting fires.

-- 
Cheers,

David


