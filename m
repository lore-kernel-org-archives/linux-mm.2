Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44984C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18D16B009B; Tue, 11 Aug 2026 13:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF01F6B009E; Tue, 11 Aug 2026 13:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06186B00A0; Tue, 11 Aug 2026 13:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC05A6B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:53:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5BAEA0198
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:08 +0000 (UTC)
X-FDA: 85089734856.13.179B7D2
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf01.hostedemail.com (Postfix) with ESMTP id 967FF40003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=plN4WIN6;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gkmc9E1Y;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Iav4WTWDleih3gHxTno0V0co2oSjUMUnY8kA1aXPeZI=;
	b=JlRajG/6E25vOvscxDqLEXS3CSG1HY5UB58g/hFkM64aGz3YbK3MRDErerifGh4TGU3Y4r
	Gipn7H3ol5FmSbXReWd6rvVh6vp9y5CQpEg90BtbboYOQWVPD2WUMtJi6NOTRIQ7s7nN7+
	0r6bgo2BbQeehR65Q0DdDDDZr9upMF0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=plN4WIN6;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gkmc9E1Y;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786470786;
	b=RO9Lvqukl3L2AQkTrNYrI6cxWZyzC1EamzukkfTbB2v7tYbdec7Nef2wUhtocYkjJmT5uw
	tsZXDMTg+NTL9/DPeDJDshialQbZrWtjBt1XzRaZ6lTRoGSBNWHr/08dph0mBgmQRiZ4D9
	tJ8GHP75C7KNi9d3w99iLZeepQkj60Q=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 233321300113;
	Tue, 11 Aug 2026 13:53:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 11 Aug 2026 13:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm3; t=1786470783; x=1786477983; bh=Ia
	v4WTWDleih3gHxTno0V0co2oSjUMUnY8kA1aXPeZI=; b=plN4WIN66oKr+N0kUk
	2oYGfm6IG+USP95UKZYKre4gL5vw96GnRsSeUVN67WcCSYWDYPhrpU0e7L5bD9qy
	gA4wsm1+/qeXdLcoy2f3wLDJr4QX97KKqXx7HOA90wcYc9uhZaGyCKG53vtLHxGg
	kcY9lF0mCh3p2ciUTeu+xegL7hm7ET9i/htAAEItFMJthcHbnggW5IUnFj2AXz3R
	2ppcq8XOjyG6ZeJWIIGx46RYRWdatEHATvRd3bFHqMOPA0Kn1joq0rEDv3/P+yyC
	WRdThmI3j44B8oerB45LzGrMlXt9IeJtbTlUneIHdQ4IsQBIBxZ3XolH5h7JDWi6
	WymQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1786470783; x=1786477983; bh=Iav4WTWDleih3gHxTno0V0co2oSj
	UMUnY8kA1aXPeZI=; b=gkmc9E1YuJGNvus/zaOK1QanaU3Yfw0ZBUPzzAdMfG8D
	SIAb6FrtNfWhNz1Z1xo4IF+i6tMvALyAkK99KOvDpcm/VGM/nhuUezjGsMC/vkjc
	8+GT+qVdLS+z7MCpGUX/tTrCidoFvJqDUxWx9s3TOtvOP15/HaJYaCn78ChLvgXT
	pEYVM0WqXQqlY2BtlmFhIJWUX746GdCIHdqc30fVuMmtOszwxaP+4wXF1aDv8KQh
	yLzce39LNDdjm4UXPB1OPWzqF2ydq4NmKu09kQzO59/rq3D+FNh6isCSKrg7yxCN
	urytTLXzk33+N7tgAieIX/Hg3ZBi7g7rs7xD+F5Ygg==
X-ME-Sender: <xms:fWF7andINlwQPOaCI-XUVarJ6Q7DMNpS0V_mgD2MyV3bQkaIaPUmLA>
    <xme:fWF7amDTRlhBHnq2w7JfOKHD2O1DZEMAtqss_c3v8WyfuENDg4Igabqn-JK5iT8d-
    Ol1vd7oCVVTcMg_uPkezsMTiG8HYmROGgE03r7dmHnjDUfNcDrF>
X-ME-Received: <xmr:fWF7anEtt-QxHNfZhlUt1zUdr1-qcuuLprACW83lq8JdERZnlK-J_HVH7CP3rwVluKgQfhWtSHJ8FodTsKLmszs>
X-ME-Proxy-Cause: dmFkZTE73aHpthgNDQ7JAN/bX2pVOvcoXVlWiDobTGq+5a5b5odiVdF/tSDtAx7lftbkw2
    G1AApVxOdPA+fYXSUMWnbeGK5Z2Bmw/3dLdFRwUiwcwXOE4rDlv0+ipGkdzZd923IWFSA9
    n28Zs9HqHQErokcmBYG/uCcQkH2/AZM7ymYb+9KKAG+yUDdABGSz2SC9YRCJK2duI8zfwp
    nhdxztlKonApDZ1bt/2wVZALEOU9flq1JhqhoQBSlZWFlpj1lRewkSGngNGK2cjj4axDEZ
    RzbQBBjJdOFzRH2klLXcWdQhkl4X1P1G8PLlK+oGPyYzc+a/+rbdUmRqC5vAZs/qOJqhRc
    fLeLLaGWcwGYbAq2UL1Wq35AiyPEYxSPXchJJImhUb/5Mg60xfu+dfZ9wSeaOGbt2dI2JI
    SVAeym+x33NQQ5B2p89V6rpMCuk0GE8SM6y3F9dGgEnZ0qWphwXxBpUIOme4NHQRNZUyM7
    1fUCA+iYIfpVOu2arbNioWF/cJ3Mj74RP3OPqc9m57O/836m9e8lEL0Vsulna9Y8jFKLBo
    OB+jZOvUk9acBiSay8z3aKzin1FfdOTwt7y8OMyJyD8MFFsXDsfBuHI6TI/QtW1IaP/keA
    pzLQb1l/CvkfUBlvwiXROgMXtav6YqYwZeHude0LqZG8WweDasIPZmffShxg
X-ME-Proxy: <xmx:fWF7amV0AcfL_-DyhkUh9TkSBq37JiNfL0jFIn69f2yZcwV98H-obA>
    <xmx:fWF7atY3sI95yVsC9BNWWqQbF6L9GI5un2IIavkwRnX7q32oalvarA>
    <xmx:fWF7agDQ-x48MABx5S-_n-0KJx4-Kt3SWJo0zoGgK1rwIEODyGWI0A>
    <xmx:fWF7aiEnv80wTiZUwjv7HHMUFrX8dTlVuHn5oEP2A6qYC4M7YLUJtw>
    <xmx:f2F7agKFrdaSXvJHWFcZ_AeCUyTDVQwVdIhKDmzmIDQA1PI5a9OUhyrc>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 13:52:54 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Subject: [PATCH v2 00/13] CRASH_WIPE_SECRETS: Wipe secrets before kdump
 (was: CRASH_ZEROIZE)
Date: Tue, 11 Aug 2026 19:52:49 +0200
Message-Id: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWNSw6CQBAFr2Jm7RB6CAy48h6GxQAtNBrGdAMih
 LvLZ1lJvXqLEmRCUbfLohhHEvLdBuZ6UWXjuho1VRsrE5okTAF0yU4aPSN7mlEzfj2/dFGAi6s
 MbGyt2qYfxidNR/aRnyxD0WLZ763daEh6z7/jd4TdOy9sBJAYG2UBxGlkQg36Td0w3VsnWAcVq
 nxd1z95g2YptwAAAA==
X-Change-ID: 20260811-crash-zeroize-rework-bb1a5d917577
To: Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
  Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
  "Serge E. Hallyn" <serge@hallyn.com>, Lukas Wunner <lukas@wunner.de>,
  Ignat Korchagin <ignat@linux.win>,
 Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Keith Busch <kbusch@kernel.org>,  Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>,  Sagi Grimberg <sagi@grimberg.me>,
 Trond Myklebust <trondmy@kernel.org>,  Anna Schumaker <anna@kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  Marc Dionne <marc.dionne@auristor.com>,
 Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>,  "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
  Alexander Viro <viro@zeniv.linux.org.uk>,
  Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
  Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
  Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-afs@lists.infradead.org, 
 netdev@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 967FF40003
X-Rspamd-Server: rspam07
X-Stat-Signature: b6n7qr5mzx9c5bs14nkus34gb86nfcrj
X-HE-Tag: 1786470786-528527
X-HE-Meta: U2FsdGVkX18m9BUhjcaybBFLr2FgRlDJGpqewHclN07zdkEllTFMaf2nHiuAZzSkLaM4ogrg9U6QgfMls374XsfwpuIy2Yz9druZ7hnHzDRW9ZsLqIGn87z1BOb+0ip/3cSyTyk+n9VPApyNI6eBha0ej0iZVuj7//MNBtJ7nUEfuMm/8ADc1ZTHNWsYv1w5gh9U/iKWzakrPio6ySD5KiG0dwYyWmiRj7F6HBfwn7C/O05rlkxQp82MV9qDJMyYRksNK9+QLAgkpuBYBIJtQFca26bf5S5LzEzMr9vkt9uqdmoI0g60nKaeyVfFuoMyg3Nr2Ftf7pJ5wkUWasxHI8qlP0REp1Mpi6Z2B29cUUSU0E+/Y/ZoUfEXm2+yHThbiIcQUzBuae2fSivBq2ED4RKpMeGiIzujNGRFyx++cJ4XYM3HkhXSjrXWfgJt12O9rj+d3FSdLgJPyAwC35nar7EUmIcZXtzikhhD402EOaFCBMgOdSluvdDI+ulyMWWF97SySkSCj4kswb3nF+CizBv1XkrIEMchSz1QT52DcIiW82hGDr+tEuCI7Jj1TBP87tmIW7hSwINb5REuuANmFhB5sQvBIuGkATvmHwuEkggN+siJkVkNufB8/wawxKE6J6cGObj5albsh7Nn/4XyKNLxPItttGp2+mtiTo+lKm7j9tcWdIqR/TRUiUaQORCNPGVNf14pQ1uSFze827sYvexxZu0SmBlfT1mu1x1RZhBoLLxOkM0A/JGITq6alRvv4ZoA3W94fRKkZoiXc+X/jYTrWoY1KIz7RsDrSzyXQVFFM0bonOHy9ESfZSvNMsGsIXUM42ITcSfe9cm1o8BEw91wpR/PHWTp1Z/6Y5kuGxz/0WEVzjKHy3y8SOUUpaBjngaqCFeYeeWQ6guHQXhVL3uQSPRp6tYN0BUECS/nuZBWe0rK1w5D8GOpbMQNFUFJW6DeNWgemJjT+hD10aC
 gkTc1MRx
 XYgTiUuefAIlWSGZpD8JwdfM4mROKOCUTfciyZuL4VAs9j9Kuc5E+oWJ4mjfCkWZ+XZ3dPFWcvNdSEx9bFrTex50pGUSEZhHhSkdW/N5OBJnUx4FmTPgFWEI1SHbCQI+/ohU2+me7jQmL5EDzzDgEJ8tI7PWDfQ6vNkJ1miengMyX9Z9ulAVkOT6vUn3EuLOLYxQAQ3W7oMxvSNJdI2GiCw2mP4FmcHSCkAmza7aOEyX55t1o44gE909D6gB5Om1J0iQsAqV5cY1EVIMKEjT/4LHz5pUe7QVOqIz7K9oGqnLObF3LPg5KV9BAGzNW/VFHCguC4FvFIAlN/KE/dnOs73qTgHUu1qftPfulW8NMDPgD2cwtWZoonMehL+AffO99iJeHCMVs4JYKQzrU0Mi1CFAGIaH6SezdI5PjO8XUzrY+EoSkv8XA3v2MbVCfsUUZCfJpzxCZCEwiWGsEtGW1vKukAaAgJ9nn7p3Uw5Yj7OgCn2EQr2UUOFGvTSBZ/GRTu+r9e2pR20cX0kUJTDe1gXy5OJcGMaDSdyuud0gdZBk2iCq6RWSTY1hTEZVw7AW4huRwZ/xDN3p/f/EUwTKKq8v+67NQpS9t5iBFE2IqdBs5UazMaFOvhCgO/p7Zk1JLnKeJlgDLRU1HvkaBuImbEUS0xZD9q+OIfcsd2iVlTqitCz510166FOmR/QuULJaXUSzQd1r3KqugAAIVx+FVBiLtLDLmslCCwf9Y5V73DYEvDGQIrTaeSPLRNlv9d3CaOJE69WWNjkJOsynZE8P8IbSerJ6j1wvLku8zjkz1wTrRHv3WTWoLdWA9katn01PpYRwPFy6voXvnjRPH3PdZfh2EAG5ta2yUFlD3Q4VRtt7Hzx+dLBMO79XebrIkY71zHROTf2kfNbdFy0L+m9T/7M3GRm7NGE/iumH9lfep2tJ+J1VG4rSZ2SGHi6g40+Hoco3Zg4qX4+qcQNyA2cjZtsiVvn7I
 kBAJKRoS
 3Hh5hAGhL9TyyjgIyQNOQcU5p+UcR2FOsAVrjyVU1QCpioYTpVbX+h2urxSlyxu1x7IATO6B0Keo6j66yv5nMg7sQ5Cu1Y0BHtUMkVhWbrqUEXA2s9GdDNmmLkLS51okxsdJo2QfMwsvxqzLM/WkQ4gnOVaqX+UxMhlj00ZtIM+nyIz87EK5q2jizbl/xBnBABjI9RWVoWcw1c59ZXKVp1F1MDEP9NsCNpCFbcaQ2Denabz7TwK35Sh0N5Q6p/EXb1Hz6DW7FL7DhBLbp7TDZKL9gwWzVYZsJlrMI87APgHAEAtCCU+HIRM/7csigb1fAVWD3nwBTKOoxlzuhbF0j9WOQgGZc4n4c2y+BrWu07jW9l3hxTMPyFWUOsAE2WbhHru9hhMt9qKF2hKH3NSlV6FFMIsxPz9bgUfncca/bOB67bmWqxoEaWExKNWriUjkOaSvl2ZERc7Wsc3vJaATfLU/8nW5wk1rdrlbIm9Rgg7tkHqTNEwNKZV5E32NjCaHQ6hQ3VL59L9kfqL+4D2M9tI9SR2excg+xOzlC3rKnOaNZZ9OCm2LhNvIZA5Cgo32jZfTPcG6yB8XpLdmhPLdwiHffKobj1Frt4F8nf44zVSDFkTZW5uhCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm using linux on an embedded target in a Hardware Security Module-like
application. One requirement is that I want the system to be able to
quickly erase its memory when it detects physical tampering. I'm
approaching that by using kdump to load into a small payload that
instead of dumping RAM, erases RAM from start to end. However, writing
all of RAM, especially on an embedded target, is rather slow. For this
reason, I propose the mechanism in this patch series:

Add CONFIG_CRASH_ZEROIZE (default off), which when enabled makes various
subsystems handling secret data do a quick, targeted wipe of these
secrets before kdump. This behavior might also be interesting in cases
where you run a normal kdump kernel but you still want to keep things
like fde crypto keys out of these dumps.

CONFIG_CRASH_ZEROIZE is a best effort, defense in depth solution. There
are circumstances, such as when a panic is triggered after memory
corruption, or when a panic interrupts some operation that mutates data
structures under locks, when the kernel cannot safely wipe some memory
areas. The handlers proposed in this series will just print a warning
and skip the affected areas in this case.

This series introduces handlers for the major locations I found where
having this sort of thing makes sense. Notable omissions right now are
the Ceph and CIFS subsystems. I have WIP patches for these, but since I
can't easily test them right now, I omitted them from this patch set for
now. Currently included locations are:

* various key types in security/keys
* rxrpc
* fscrypt
* dm-crypt
* crypto tfm instances
* secretmem (which I'm going to start using in my application)

I've verified this patch series on an ARM64 target using the helper code
at https://codeberg.org/yasec/crash-wipe-test . This code stuffs the
affected kernel subsystems with keys and secret data, then crashes the
system, takes a RAM dump and verifies the dump is clean of secrets. Note
that the helper code is partially LLM-generated, so read with care. It
passes a positive control test with the config option disabled.

The patch series applies on top of linux-next but should work on 7.0.0,
too. I've tested the patches on a Arduino uno Q (Qualcomm QRB2210,
ARM64) embedded target.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
Changes in v2:
- New keyring key types
- New handlers: rxrpc, fscrypt, dm-crypt and crypto tfm
- Renamed from "zeroize" to "wipe"
- Add ARM64-specific cache flush logic
- Link to v1: https://patch.msgid.link/20260731162739.158320-1-linux@jaseg.de

To: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <baoquan.he@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
To: Dave Young <ruirui.yang@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: David Howells <dhowells@redhat.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
To: Paul Moore <paul@paul-moore.com>
To: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
To: Lukas Wunner <lukas@wunner.de>
To: Ignat Korchagin <ignat@linux.win>
To: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>
To: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
To: Sagi Grimberg <sagi@grimberg.me>
To: Trond Myklebust <trondmy@kernel.org>
To: Anna Schumaker <anna@kernel.org>
To: Mimi Zohar <zohar@linux.ibm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Marc Dionne <marc.dionne@auristor.com>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jaegeuk Kim <jaegeuk@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: Alasdair Kergon <agk@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org
Cc: keyrings@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-nvme@lists.infradead.org
Cc: linux-nfs@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: linux-afs@lists.infradead.org
Cc: netdev@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: dm-devel@lists.linux.dev

---
Jan Sebastian Götte (13):
      kexec: add CRASH_WIPE_SECRETS to wipe secrets before kdump
      crash-core: Flush caches on CRASH_WIPE_SECRETS
      arm64/mm: add set_direct_map_default_nosplit()
      mm/secretmem: wipe secret pages before kdump
      security/keys: wipe key payloads before kdump
      security/keys: implement wipe op for user-type keys
      security/keys: implement wipe op for big_key
      security/keys: implement wipe op for trusted and encrypted keys
      security/keys: implement wipe op for asymmetric keys
      rxrpc: implement wipe op for rxrpc keys
      fscrypt: wipe master keys before kdump
      crypto: api - wipe tfm contexts before kdump
      dm crypt: wipe key material before kdump

 Documentation/security/keys/core.rst      |  13 +++
 arch/arm64/include/asm/set_memory.h       |   2 +
 arch/arm64/kernel/machine_kexec.c         |  20 ++++
 arch/arm64/mm/pageattr.c                  |  21 +++++
 crypto/api.c                              |  78 +++++++++++++--
 crypto/asymmetric_keys/asymmetric_type.c  |  11 +++
 crypto/asymmetric_keys/pkcs7_key_type.c   |   1 +
 crypto/asymmetric_keys/public_key.c       |  15 +++
 drivers/md/dm-crypt.c                     | 151 ++++++++++++++++++++++++++----
 drivers/nvme/common/keyring.c             |   1 +
 fs/crypto/block.c                         |  10 ++
 fs/crypto/fscrypt_private.h               |  15 +++
 fs/crypto/keyring.c                       |  68 +++++++++++++-
 fs/crypto/keysetup_v1.c                   |  15 +++
 fs/nfs/nfs4idmap.c                        |   2 +
 fs/super.c                                |  29 ++++++
 include/keys/asymmetric-subtype.h         |   5 +
 include/keys/user-type.h                  |   1 +
 include/linux/crash_core.h                |  37 ++++++++
 include/linux/crypto.h                    |  11 +++
 include/linux/fs.h                        |   4 +
 include/linux/key-type.h                  |   9 ++
 include/linux/set_memory.h                |  17 +++-
 kernel/Kconfig.kexec                      |  16 ++++
 kernel/crash_core.c                       |  52 ++++++++++
 mm/secretmem.c                            |  53 +++++++++++
 net/rxrpc/ar-internal.h                   |   5 +
 net/rxrpc/key.c                           |  34 +++++++
 net/rxrpc/rxgk.c                          |  11 +++
 net/rxrpc/rxkad.c                         |  14 +++
 net/rxrpc/server_key.c                    |  11 +++
 security/keys/big_key.c                   |  17 ++++
 security/keys/encrypted-keys/encrypted.c  |  13 +++
 security/keys/key.c                       |  43 +++++++++
 security/keys/trusted-keys/trusted_core.c |  15 +++
 security/keys/user_defined.c              |  15 +++
 36 files changed, 808 insertions(+), 27 deletions(-)
---
base-commit: a0dbb7d3457bdebe2dbe198bd08bf9690be5f1ec
change-id: 20260811-crash-zeroize-rework-bb1a5d917577

Best regards,
--  
Jan Sebastian Götte <linux@jaseg.de>


