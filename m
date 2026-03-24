Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C1BF532F0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D816D6B0005; Tue, 24 Mar 2026 04:27:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D327E6B0088; Tue, 24 Mar 2026 04:27:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20F86B0089; Tue, 24 Mar 2026 04:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0B316B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:27:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D334911C0
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:27:07 +0000 (UTC)
X-FDA: 84580276494.25.2A25C2C
Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	by imf01.hostedemail.com (Postfix) with ESMTP id 585A740005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:27:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LsJ8vI96;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of yc1082463@gmail.com designates 209.85.218.68 as permitted sender) smtp.mailfrom=yc1082463@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774340825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iY3Pv+tW5apRti3EZqkrp4754a1L1kmD0NBcMgeASTE=;
	b=U2jLqGuFKTUdNV+4OgNp5p65iP1sDe7E93OJR98VMCEO6m0/wcWLWawKrw92jjlIFw5M3A
	8md2uS932hOE8A7gHdOc2sbjAiwqzMGKzMAe7mAlWETrZUy0F/JMqomyROfWSpqhfbofC3
	Ou3VIIpAprUROkhklELsOqeO1qmUY1o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774340825; a=rsa-sha256;
	cv=pass;
	b=NULOjZwwxAIb2lx9NC02odc9SoJ2Rx3VaeekniDxYDQfdW+1VtabNlyPxN9dWAAiWNSreJ
	iLDdmrOPwgwwO3baNsX5W2tNW8GTblbMW+22ZrR/SGgwbqU3UfdHP/cosnJmQXxk6Y3q/v
	PUonNIQicRGovLB8/w5+h0bYkTktjqw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LsJ8vI96;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of yc1082463@gmail.com designates 209.85.218.68 as permitted sender) smtp.mailfrom=yc1082463@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-b9910707d82so24605266b.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:27:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774340823; cv=none;
        d=google.com; s=arc-20240605;
        b=dGKYMeCwMGobLUC83GiuiNOyqPT9t6Ju1Zg4oHqczF9ZBe7CHAkfiRghMZe5j37s+n
         yCncNZigIaGSfUls5fX9bBYO+od2Ebkl13lTw2/66Zj9e/65rSxripyy48uFnsTyIxtv
         Zu0s9gpUHPReY1ScA5nKNFv/JJ7KW3POM09xlNwaphHcaDiAlPT1ySzkHTFjid71trWw
         ROAJAei1FENW1Cl1LTSatjbQ0ssMHOwTsHIpcZehS4voEgJnYk2e0jros8GTMrr2goUu
         Hueh2DQF8a1pPSmJ3iAzX/UGdMs36e8iGdQQaYc57y1jmqhQM15azraHLKzS5u/nKLgH
         k1Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=iY3Pv+tW5apRti3EZqkrp4754a1L1kmD0NBcMgeASTE=;
        fh=8//5TRcW4NVLXQAD0AO/QdB9ON8Uy2mXBfkjVEHT4KU=;
        b=fW3SsW/Hye5j19evSnwztf0uw4sjmBkAUE9tyiA79lzEFob0akhcbcEtYkMp6GW0Iw
         wr546Q9Y1EP6DW4f2yoj/5WXE+LNUUCMvkR851A89KpBRdk0U7DbpKqUmoRYKv0qKPfN
         dlAWNpmjpFQvWrzlRCHTyMNM9/g7X5rQkzpVQ74X5G0KEYXgshlEKRrVhDPmcJPh63PF
         XSTT2dpxrDgoM0p6mJZZdVN8ouEsRfoWGsdOwiHyjigi3iwQBya1YeOqnFarZddyES5F
         vnOLCrgHiQVxazNg9QrtS/6wBudQbun1MFoOimRCr7jKW7Jfwz3WVFaTFJPaWe6BBu+p
         CXpg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774340823; x=1774945623; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iY3Pv+tW5apRti3EZqkrp4754a1L1kmD0NBcMgeASTE=;
        b=LsJ8vI96THuyYXhLsIi0n2jNitXKpXwpzmF7ZmYckhTCaElxOc3OGQ25SOvKgMbsgd
         /m7pKdFxkG3hg2lUlG79x7AaKnLCXEF3UqoskP3dPH9RXwq5R1VTClsXesADEjXvKtUI
         kfVpwf6tSXLXhuTpStuSviYcejL+k3wxoJR/OmL/CaxVvLL+AUPVzHM+y8eTl33B7l6M
         M9lTfalkzyNlmuZrqnSY1htcAUeCK/FF044I0HM9loWXaZQ8pvH5tytpGMSbKfEJGweI
         ewfWL3jUK/DqMb+4iThYMkg9DMC0mASornaHaRn6brWNLUelg1e5NcdwnHmpTX16uViU
         6zrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774340823; x=1774945623;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iY3Pv+tW5apRti3EZqkrp4754a1L1kmD0NBcMgeASTE=;
        b=mjMIohm3oZWju7PwFs0ecGE4YX/PV3c4BfkxC2MLe9nHM69kEuW92YxXzzPeiRRwkN
         A+fzdL+k6EzT8UI9TE4jxNgS+Ve6t00Daf5w43hUOG7MQIw8NhEBDF2VnxIgnqMwjEUt
         SZRqpifPVL5MgmKLUfc9cWm8jCY4XVT3l/4S5G5qu3cwuhN6PDuy+EOwJMoEN7Gw2ynC
         76sklqMS/0RFBJ7heGNYiKoq0O0MSkok4z6xE07YM2n3MiGXmg6n2aiiYzvrEmSsYRr3
         eTdbh9iW2/HykJzrcmyeSnOWqePT18Vcr6PNlwsa29rqb+AnbizMXGUsY3i6OaG5qNKm
         1Clw==
X-Gm-Message-State: AOJu0Yz7PYLQS+lCcnRV24aS+yRRM9bnq3ov+sj1QRnaoah4BBMcYkjk
	lbpeZZb//JcUY8SaJLDs6gUB6z8wiXoOzcjDaKRauBTtux8Qai1sooDTzMwVItli/6AgYRSV0fX
	eIcvTPoynBcqWtwXfCfbUlB6DnA7p4c1C+hpoxhQ=
X-Gm-Gg: ATEYQzwGN2i1DzvgcHRmmWJKq5DCJM89kK+Vq22YQObBx0vVAtRmWJFk/uSYTnwliMT
	FONfHSK8GvkPKW5csXUeYTm/hfk99LgYKVUUkkKWFyjCbWSg0UMUIVlry+m6K/hk0hzvaLF1R07
	RpFWLG8jciLIvLybYpojyIx0IbkI/TpyyntF9XmU44pkeciRsB3FuxlWOhajRZwgXMd/piZNsdv
	NVd6DuWtqAs+TBxWdjEJyE7YM25puRxPIQsfmAUvT1ZHaKT6jTIGsnig2TAwvbG0qBrB6Yh2dSr
	a/CV1TE37RbKAJCmILI=
X-Received: by 2002:a17:907:9407:b0:b98:6c41:a758 with SMTP id
 a640c23a62f3a-b986c41b5c2mr457074866b.19.1774340822778; Tue, 24 Mar 2026
 01:27:02 -0700 (PDT)
MIME-Version: 1.0
From: ying chen <yc1082463@gmail.com>
Date: Tue, 24 Mar 2026 16:26:51 +0800
X-Gm-Features: AQROBzDApd-lcJyoFG3o-8magek9CsQG1Q6TBlyspZ0oybgHMkr-1hBiED5WSOY
Message-ID: <CAN2Y7hzb6yfHwHdwMC1TTP87dbnn=BHyyWz+iCQ_EswN5jVjeg@mail.gmail.com>
Subject: [BUG] rcu_tasks detected stalls in kcompactd during proactive compaction
To: linux-mm@kvack.org, linux-kernel@vger.org, paulmck@kernel.org, 
	akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 585A740005
X-Stat-Signature: u8wdjcq84ewochb3re1uqrh998zirkce
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774340825-29435
X-HE-Meta: U2FsdGVkX1/gj4JIUNxrD7IRP6WqaL9WBHrPv1hSbMsxWq/8A56JaKU6FA9ZtlLK2k2J5NySfznm9al7xzCHt+EAlRabO5MSanlmx4IkRY1Bpb1J400bbs4HihEFeeoM2DMqQwcH5aZ/WhnLvyAC/tJzhISzbCKyDqfWZOLcHLOUrg+hXnuSmHL5bM9YWHp/bSkgkBc8C4C2AL3/z7OGWWNS5mHwnp3w4WlmQPdIakrNyYgxPCL07VxqeKADbxYg5p7pZb3saXnmclPtFsKVCYgE7EdwfZaVfI/qT384K+i95z6/ozJGl3Akrpxc1e0nHbJmHlmx56knWyuep6Ip4JnWjUUKq+CRrpQelCV/CWL3sXoefV3ydiYM26mOhLVAN4RLx+0SSWpqHf56IDUlOr2nWguf5OMfPPw6sDyi0EvhWz7ny6P6a1usfGC2VZAiwoPNoVO2EXtOonQGa+ACM/Iv3KMqYZDP0zFVKPRGTAd5ZYXpqW8qzWvlF3XaPftRACwHqblAyjwr6hmiIuDHuVyCl8Lpo092NamSDMbg/MQudSBUB1zLHtfPoHFZdeVcfbHEaixHlio8YAgYTUuL5KbQELL7zJl83JHKSZe1r3q1s2z9WtRk7cHI1RXZVI6Lf9UPpMvVRAb7wLhRv56S9wHVOfpCDeaYyhT03wBsDMsF/6YmhYz81/ALO1qiuVpIDVjC3g+XL+WFM/RVQPCs603Oq6VegTtAOE4MwAMaXlcDWH0f9ZCOyAtgD3BPe8KaKU1ciO9wxs7Ir6QRbo0Sx1bB+a+jVJThPbCsHGrvtthv7vjI2C+ur6Bd5PNoMIShsws9B+7tnGhHjr1ej9VkZmoPV8MDwjcvxnJ9d2Bmre80SYmkaMq7p1AQMk0rlGH/wzTd0CnrTHY2/1StNLmQ/nZdfP+U6t3BwvQ5zaVnH26cMfRnnO33x8ohBDY23zTvjQZ6kdrpNxucFSHK9CB
 uCmToQxL
 bLKX8/6HqUv8z5FZYgigzumUjNf4ZPrzlYPwU/zI6Swyvhk2HGx3ulbqLeYDde4u2Dc6pRaQO325WLQNDOieI5JfJLMZ//UbzoF7wJr7ZJkt2ns5qHfY4eVaOMGuOquKmnKtUp89sW56b9HSjZdUXmL+8YYUXGq4N0ZxsDJOzA6hlMTKHQj7roFGJ/o+oBtftgtCswWB2tZ6WJ31B3IMwxAVEq8BJSKF+dAEDjuAoKWZOa+udT4gQynUJqFXF23dWOF+VrKc45gJRfVMjotjEvz16orDE5/hN/7lUB6DqP9ucxZuZ8w/7Qyjod7rQS7IvPWAqfAacdYqaBQLmfpGqvCb7j3X7Oxfn7xFOpN+6/PLDZ/9EgbpK+T9Sz3DpRJ4SVUs2uhIddQ+9dcs2hcSyvMXxxcSyyj7Xfx70wKX2AsfatiEupmUkiYhpVpRPclldzVld8ZcHMBrGXj4hpeO5a/Yvlf5zo58VXe2CWxuYIpo0poXfIVrOeZiKqOyirRebUjKMoZjvOEOa0251SiU5+RDWIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,
I encountered an RCU tasks stall issue triggered by kcompactd0 on my
system.Below are the details of the incident:

Kernel Version=EF=BC=9A6.1.0-x
vm.compaction_proactiveness =3D 20
CONFIG_PREEMPT_RCU=3Dy

[Sun Mar 22 16:36:04 2026] INFO: rcu_tasks detected stalls on tasks:
[Sun Mar 22 16:36:04 2026] 00000000fcafb4d6: .. nvcsw: 622963/622963
holdout: 1 idle_cpu: -1/1
[Sun Mar 22 16:36:04 2026] task:kcompactd0      state:R running task
 stack:0         pid:1943
[Sun Mar 22 16:36:04 2026] Call Trace:
[Sun Mar 22 16:36:04 2026]  <TASK>
[Sun Mar 22 16:36:04 2026]  ? rmap_walk_anon+0x16b/0x330
[Sun Mar 22 16:36:04 2026]  ? try_to_migrate+0x96/0x110
[Sun Mar 22 16:36:04 2026]  ? try_to_unmap_one+0xd0/0xd0
[Sun Mar 22 16:36:04 2026]  ? anon_vma_ctor+0x50/0x50
[Sun Mar 22 16:36:04 2026]  ? folio_get_anon_vma+0x90/0x90
[Sun Mar 22 16:36:04 2026]  ? invalid_mkclean_vma+0x20/0x20
[Sun Mar 22 16:36:04 2026]  ? __unmap_and_move+0x21e/0x340
[Sun Mar 22 16:36:04 2026]  ? free_unref_page+0x17d/0x1f0
[Sun Mar 22 16:36:04 2026]  ? release_freepages+0xc0/0xc0
[Sun Mar 22 16:36:04 2026]  ? release_freepages+0xc0/0xc0
[Sun Mar 22 16:36:04 2026]  ? unmap_and_move+0xaa/0x4c0
[Sun Mar 22 16:36:04 2026]  ? migrate_pages+0x3a9/0x790
[Sun Mar 22 16:36:04 2026]  ? release_freepages+0xc0/0xc0
[Sun Mar 22 16:36:04 2026]  ? isolate_migratepages+0x2a0/0x2a0
[Sun Mar 22 16:36:04 2026]  ? compact_zone+0x310/0x5d0
[Sun Mar 22 16:36:04 2026]  ? proactive_compact_node+0x88/0xc0
[Sun Mar 22 16:36:04 2026]  ? kcompactd+0x365/0x3f0
[Sun Mar 22 16:36:04 2026]  ? membarrier_register_private_expedited+0xa0/0x=
a0
[Sun Mar 22 16:36:04 2026]  ? kcompactd_do_work+0x2a0/0x2a0
[Sun Mar 22 16:36:04 2026]  ? kthread+0xeb/0x120

