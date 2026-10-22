Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42DD606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 00:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=llNDq7wr
Received: by kanga.kvack.org (Postfix)
	id EA8FC6B0272; Wed, 21 Oct 2026 20:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80866B0804; Wed, 21 Oct 2026 20:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96B26B0805; Wed, 21 Oct 2026 20:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B71426B0272
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:20:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FA6B140695
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:20:41 +0000 (UTC)
X-FDA: 85348356282.21.77657AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D1C66140009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:20:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=llNDq7wr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792628439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U160OhCDm3caKtoLaOhiSMfGfQJGF31Y72hqDHrZ/jc=;
	b=kVAA5x5x5mmW0j6Jq6rVh3nfNqpeB7zlCiMUNQ9BNLHTtT2VSrhPm0h4NB95+H5xDRzTqP
	o7ch+ufWIHjgk4YQtNK0InbNcu8CmcyCySaUjiT9OryjwIZ/YrmfU6Zk8JXdrZxgd/ixlx
	qvLhiGm01wz8u8yN37RVoclT7emfLCo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=llNDq7wr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792628439;
	b=bF4j/k8Hl42AYLzpCeUzT4a/KYsY6fMH/GVnyfS3S0bwcbIlJPmTLf74kVPpDCXqIs8ns6
	eW/pRrmp4Dcgfq2CwkaMUrv1i0/AJTXvkpC3rfhy6WRtfWb4XhRpaCqQiXUCOgwvcAL2I8
	mV8W1hctNqtrUwDxfJ0lnmqsMWBLRqs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73CA9601DE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4D11F000C1;
	Thu, 22 Oct 2026 00:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792628438;
	bh=U160OhCDm3caKtoLaOhiSMfGfQJGF31Y72hqDHrZ/jc=;
	h=From:To:Cc:Subject:Date;
	b=llNDq7wrV6MxufRqHZpgUFgyLDnog42KLTCk+myzhfYCnHp0LR9CjOgCSrogX1yiv
	 EieROOVa3zg7L0SXKg2k7tPgkOleIWBTfCF/HOfr6HEMwEofE9KNVSxNGV7XqIUR5N
	 Ph8dL/khLeSJQ9cUhNM5YSErZlyDlttsvNhjakXtefmGHbgr6aEQuGBDOD4FWqkjz+
	 rmD99yYhCJwSHjSITfzzx4ELi6T3o6wxeWML8OSwvG7kNUxdn1aUdammBt9NopKs9r
	 cOadhxhASA81GZxjsZXhlLf/qCZlouu+EQu6TmL0DqfEVWswxtFrpf0iOUq6PsH0V3
	 10eEBEMrZ7iiA==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-10-26
Date: Wed, 21 Oct 2026 17:20:30 -0700
Message-ID: <20261022002031.87137-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1C66140009
X-Stat-Signature: 73g8xhxnx5fi5esuo339eecxm7qe4ybx
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792628439-404352
X-HE-Meta: U2FsdGVkX18gWyTCWp1ElSk8AWpvIJ40pwpJAJuVDRfV9Lg5jmw/0+g5eBIw+8PR2WRD2u6Fxu0QUKLoCxzg+QLwyPj+MBiu49Ty6n9LaB5Q4vvfPzWP6SPkMxk8kKpEfus/D13QMq7g3WWbE+YIgn05EMYt5QLOs3ahEQ9Gr33Vy3ohwzKpIR5NwaMRvuey0ZkUkgPG3Pm4qsNhUoi8zMODZ4ivlqrbLKbK52zxqTc+laQ/C54znR1wNnNpQF0xKHbFiAZca3dwFLImNDLcW3TPa0Hz/zzgT/y+qZ6Ooz3vronE7R3k2wCGEDYDSQ0Xx063qyE0DOUCW4NZ6BD3SUID/mqARpAtxclbQmdCVOZ7kidQQ+OC1DqyN27pRIRZOP7r5bWYmxSd8uZP3cTogHrZtkyY9HWduReQhFvc346kRxj86Yrb0CgJtwI8j7vDs690vpiNZ0stsmP57cWSZhqPfnnRXF9gUQ0wkzCXZdaDgbr/hlqholFJ+mGehC1Kvo/y+LVfgxp9bmMLGb+ilgDMXY5K+IAhcZFodY+/VdgaJS7coM2oNz8gV6cL66PihovNuEQD45VPJSK5hvTBjqKqVlEY7f1Fh91jL5SqaJ6jgV41rENsVw5i/MH1DYVRxEyIKi1aHJDX01FSOe0OZpVBpUg3FH0E0ob7tQLH4VQGrOJC+wi0E6qHdtpLkNp50C1f+M7rOCKkQ8syXTKxadinCekTUZ2gE8koPZ9ORB9j0aQswkeBrcoQILlR4w4t/Dm1zcUO4VOH9Nb797MQtZHkv/gwKzTYP9g9jqGLDZ4nHg9zNHoC4f1P+BgZG1zhcn3cw0zaTFXYGNMcX4NEM5oNt2Hjy1N9A1sX1wnrnxSqI3FHmIqAnMFzilxltI5n6qZiMLFSdCDWgaZ7JcjqfDemHkQ8l6W7bxOIC+CW/EiS/c897qQmi8dIKJpGkgl6n+DdN9wodtt4X1XMhRH
 QzfDVsao
 ZlUfQgcDZMRnmU19DfD2xp9lCge5X7ilrxkLhoO9ACus/KXwX93xa+SkzS4VfwE1A/wIua7kBTbRkN9yH2sHWhatXlIp+On4A0JnGUOUkd1PIWoAue2j+bBBiRldMvWbKwsFtNznNSNdDlebA+BS2NUZFDQ0EX/SH344Osl6HB5jnbAfJm4KdATMirahmS0jwu85jURPa+dxA6Tb8ja6MKUP7ImE9Unyh/0YtN1x0jHhlOl0Q+DolCKa5TOTw+n+RD/VvLrVIDDEfhrDinM1zileiKdMr+stp7kW5XFa6Dc7jiYJRTsarPjc57G8unwwmgV2Z4ez8PpMFXMJJWYOtizl3uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-10-26.

As usual, we have two time slots for meetings in the week.  Next six time slots
are as below.

2026-10-26 (Mon) 18:00 PT (not yet reserved)
2026-10-27 (Tue) 09:30 PT (not yet reserved)
2026-11-09 (Mon) 18:00 PT (not yet reserved)
2026-11-10 (Tue) 09:30 PT (not yet reserved)
2026-11-23 (Mon) 18:00 PT (not yet reserved)
2026-11-24 (Tue) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t


Thanks,
SJ

