Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D391CA5FEC
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 10:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2018C6B008A; Sun,  4 Oct 2026 06:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C496B008C; Sun,  4 Oct 2026 06:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006A86B0092; Sun,  4 Oct 2026 06:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C834A6B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 06:51:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A0061C3F1D
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 10:51:30 +0000 (UTC)
X-FDA: 85284627540.20.DE5B011
Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 924D880005
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 10:51:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RehzjDjk;
	spf=pass (imf02.hostedemail.com: domain of anshumantewari123@gmail.com designates 74.125.229.42 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791111088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OU10JUkOnCjExkP9pLJslSiL15VSpV7uAw3VaBnuTMo=;
	b=6+p1dKowcozfwrtqZe9f0ZhjdcAaFh0UzXK1dQRCIxRuMEOTc2pGJQnSfTBa5qs0DBf/yr
	EDLGpJY1RnSwT9LGM5RE/C25Z6s5TJ1elXyvBXYgbf5S7jjamuLPEaGibVCpVLxql9vVsE
	MVkMKZKKF6Sg88zCbupYCRB/iq3zelA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RehzjDjk;
	spf=pass (imf02.hostedemail.com: domain of anshumantewari123@gmail.com designates 74.125.229.42 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791111088;
	b=AA+mHEc/y/PH/6TUFISsqf4uHI2bYUJGg7OXq5X4pXY+a5ZqHmdMoNLN2tJNyQoO6KKfgB
	Z3Wc2ABLqvSfPVX3xKpz00b3OUVlxXLRVfzi4VPHsP4bOkqgcCwtUuOrkGHsGCkXHttHgF
	6MrR7xmAzX3o50ueoeNpySEGLVcL7gs=
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-3510b42f4e3so843164eec.2
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 03:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791111087; x=1791715887; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OU10JUkOnCjExkP9pLJslSiL15VSpV7uAw3VaBnuTMo=;
        b=RehzjDjk/8TGB85E4HyLVrj2MqXp2i+kF94Pk4V+OdaoHew/zG4V4FgBDZYNU37EH7
         kLKYR1DkkHCA7xM2LYF6yfjFSiwTSZUThzXqV6p4AyQ8Yj3iuDyanNNuIM/rYwInd943
         /lu+9RtDHVNZ90mNhujSe9PF8NQM5LvfMQqvpyk7WO9zR24jcg+ew9+jyAsXQDtxKT75
         lM6xeeXf1bOzYWM7HXdexv0ZHgrYfZb+9agTz4tUHH3eXE3P0GzNBhwev+tc7pWOaQAI
         0LEQVxZAHydvJGPr5FH91FwAOk91pAkLE3ruSpget6GBH+GPqN2zGfL4+oL983yfC4Oe
         /Npg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791111087; x=1791715887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OU10JUkOnCjExkP9pLJslSiL15VSpV7uAw3VaBnuTMo=;
        b=QG2FrYl/scwqrESsUKBqKhXSzBgWmMPktC5PU17sgutolxiPaLW5Iut+1G9s8xGGcx
         rErAwNT7jZl761rqir4nYP8Bm9EwbadGpeTcUOOUcv3WacHugIcrreZ9w35WlW7ptrWq
         VpMtn016dWCH5Fhc+78s/iHSi1XMU+NuLYA3dgNJbWpa+BQ4K9I0Fj2nVT3RxM4i9dvJ
         Ym7vXTMDIfYfbP/wsRbAMI+jgr5L1hqyeeREDTVsSVIY2hyHXZfyj6aPpQqkS5FH6Mrc
         Uj0fxyPciKOFdyBAo2hz7K+YGeUHfxdFVSju4mJVEQaPA/nCunSkbF8MkiLP9+EwTKiu
         uBog==
X-Forwarded-Encrypted: i=1; AKwUvBxVIsImlsm6504Id7RoyGn7g6SEhsNBweMeH3VrEADh5Jml34f8nEu5LgnZNRmwB4frBzlbW3PZpg==@kvack.org
X-Gm-Message-State: AFq9FYICQjo33o1Asz/dy08hfsoFcembo/9CSspqnYzXhlpLaAJRtlFJ
	uV9NoDcnTJYiCEZ6imzln9Zwn5DroyLasRAlGQqcrE16Hy00cAJkxola
X-Gm-Gg: AYBFou1/wSOZ7b03Nm6cpQN35U8A3iUY1rcTJkWjtN6rK3WohMfDb8puI2naddyQIqw
	BnIvqLeHiSueiSkiEjMRfPlNcq+QCvhXttdlTONQnL8qrDpng3oQiqplMwprdCwJA+4ghJtGMVt
	5HZGeiry8GL7jYl/Kd5vnkjGd2RUAwgfU2f7Pwr9Zs+aPsRGGs/vvubjoO5wCRT/aWTYdjYWY3s
	bDzvxEX121kUrR6ug1ChS46uZPdKJESWdox+SA8EeNHjRRilCZVNy658nE3+8hV3/22mypYyecI
	6SJ+jjbYu1pBCC6IanaFZs2maOUoROKOJHK9uaHqptULvFTVHbCb38AweKWYO6LWMWkOfrZWysj
	IBFUK+6+4sAO0tdoyONeZnXwyfyRg49hAqval+Jw/FtInkJNeSUPNTnpqktJMbrtDH/EbO996YP
	/oxs8SgjUXw9P0lPF/0mEd3dx+1Qo5aSJkFfkW3rFo0cVr5/OuT855LS1A/3Nvd1j0pC1mgs3nc
	ZceW38DzfLAn86yj0D5aLm8R3m08spQEEr1oOnyqjLwl0M=
X-Received: by 2002:a05:7300:e5c2:b0:341:3ca2:de2d with SMTP id 5a478bee46e88-34f15077edfmr9383419eec.6.1791111087081;
        Sun, 04 Oct 2026 03:51:27 -0700 (PDT)
Received: from Anshuman ([123.63.59.156])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35127161474sm3815965eec.13.2026.10.04.03.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 03:51:26 -0700 (PDT)
From: Anshuman <anshumantewari123@gmail.com>
To: kees@kernel.org
Cc: Frank.Li@kernel.org,
	James.Bottomley@HansenPartnership.com,
	airlied@gmail.com,
	akpm@linux-foundation.org,
	andriy.shevchenko@linux.intel.com,
	anton.ivanov@cambridgegreys.com,
	apparmor@lists.ubuntu.com,
	atomlin@atomlin.com,
	benjamin.berg@intel.com,
	bhelgaas@google.com,
	bp@alien8.de,
	bvanassche@acm.org,
	corey@minyard.net,
	da.gomez@kernel.org,
	daniel.lezcano@kernel.org,
	dave.hansen@linux.intel.com,
	david.e.box@linux.intel.com,
	dmaengine@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	dvyukov@google.com,
	elver@google.com,
	eperezma@redhat.com,
	georgia.garcia@canonical.com,
	glider@google.com,
	gor@linux.ibm.com,
	gregkh@linuxfoundation.org,
	hansg@kernel.org,
	hare@suse.de,
	hca@linux.ibm.com,
	hpa@zytor.com,
	ilpo.jarvinen@linux.intel.com,
	intel-gfx@lists.freedesktop.org,
	jani.nikula@linux.intel.com,
	jasowang@redhat.com,
	jbaron@akamai.com,
	jgg@ziepe.ca,
	jim.cromie@gmail.com,
	jirislaby@kernel.org,
	jmorris@namei.org,
	johannes@sipsolutions.net,
	john.johansen@canonical.com,
	joonas.lahtinen@linux.intel.com,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	lenb@kernel.org,
	leon@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-modules@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-usb@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	lukasz.luba@arm.com,
	macro@orcam.me.uk,
	martin.petersen@oracle.com,
	mcgrof@kernel.org,
	mchehab@kernel.org,
	mingo@redhat.com,
	mst@redhat.com,
	netdev@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	paul@paul-moore.com,
	pbonzini@redhat.com,
	pengpeng@iscas.ac.cn,
	peterz@infradead.org,
	petr.pavlu@suse.com,
	qemu-devel@nongnu.org,
	rafael@kernel.org,
	richard@nod.at,
	rodrigo.vivi@intel.com,
	rui.zhang@intel.com,
	samitolvanen@google.com,
	seanjc@google.com,
	serge@hallyn.com,
	simona@ffwll.ch,
	somlo@cmu.edu,
	srinivas.pandruvada@linux.intel.com,
	stable@vger.kernel.org,
	stern@rowland.harvard.edu,
	tglx@kernel.org,
	tiwei.btw@antgroup.com,
	tursulin@ursulin.net,
	usb-storage@lists.one-eyed-alien.net,
	virtualization@lists.linux.dev,
	vkoul@kernel.org,
	x86@kernel.org,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH 01/11] params: bound array element output to the caller's page buffer
Date: Sun,  4 Oct 2026 16:17:41 +0530
Message-ID: <20261004104741.51238-1-anshumantewari123@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260521133326.2465264-1-kees@kernel.org>
References: <20260521133326.2465264-1-kees@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 924D880005
X-Stat-Signature: qsunbpurdsrhz5ou3upywny3aq3wxubz
X-HE-Tag: 1791111088-80533
X-HE-Meta: U2FsdGVkX18YzyBvC9aXON1W/QTgPQ0MBaIBQsI8YlgPFOZ3H2hMO/IQqcPF9Mz5xPv50FRgAFJHYWiijRlypvgTvrUj94zugqqvf6ih1ihB2wInobBPXh4K/5+BLChsSQ6wM3h4dawgwfQFfkILXRX/UFGgenmJ9KP0VzUnLPSK6WFevLiw+p4AsINHHRlkE1oZnMj2PIsZhzjjgIu3NQ3S3kv9rU9mYLD83GSZShVAuglG1bOS53L2eTAGoeP/b+1qV6rqLVW/m6FWqFsz1zNT+bs6fD139Zf44nVWHTxjOWbadkHg+bHQC42qq/eFeK6oolrER8PDnX2Ducm5nuBBm5qf6sGaYyH8mWHyD6O/uM8ivghQGSAnG2sesaf4ZhQunR1UDt0kztl6r9I+I+R4Kc3HyXI3vBXXyaW8Nk73XwF1a+Ee5WhzikMX9w8UszjEKB3yJt3aqM5vWYbh/dBojNEL2xoDCtHGy3izcFg9Qdpm4sQwnRE/4oA2fROgKNfaDDIxaqtcxIBsNorl51WqVbv4Y6XsDUDYnuMnLEA+LGTGnBN/oWE8G9JBKlm+k9pCj4dOuxtRg9FntuURasiCb4kAfuhdV+fDz+XasA9FlVmJ3t+lpPojscErzqRjlXF0DF3Ilt6QVXI1X0xXIKMs8DQccJu76Zb5HMnERfWKOf1dCkRnuaWoaa+I0ZyQsIbJymBXPsfePx7H23SA3IYdukFcZGvswcxgaOD383FO2KBW6dOQblxSbu/MgNJwiA1RHEZJeFJzU3tlFhP2FXLUoPMMTTYZzFUPIPP/3b6Jsm9OhyxYyEjMWDLEzhsF5US7yqg7By8WEYVYSQoVpr133RAe7Rc3+hbvwrB9UDbo8qN1myveouA+A+zuEIXq7JOIX4HeX1EmDrWq5KjxiE8xkeEH32ebyYZFA/B9YcvLXgOo8iIspxkPvUwMux8rfLrbcrWbI1y/Bda73DE
 EsKVOEO9
 4ODBH8qF7WLz4tQ7PKi1NkYf+jmQf9FAOYv1Dl+28dcSOBvtf/zT5P/+9xL3NXim6tF8FOcmaCF2ZTlshCo9B/AD6jj0GX3qaDFk2gZRDPyXZFOHpPzOBYrWEn7bIYjAuv53oVRyeUqRnJO5zngz9ruDu6v0todsED+5utWThUexN3bxAfhoMmhommyEt96/gri/JIHDnDGHZa/5O/WZtIuQWQWSonbYpGHgbDUrT1/BqTrrqpjeNgaTW0ePP9O1Lz+37M2HPtrgrZW6F9aaFQ8+STeX613wqxU+072jWxubgJvyPpsNJ9F/V8MPOnToWrtJnWoKM+486eICyQLY9H4l76Fj8uT9Tsv/PaI+jwCWhdWCgVwTh6dns7xxFf0AaLm3l3ceKVrvGFwjyjKGnn1IjKlVqr9/QN3POi4LxqJ8CAwBipHIxofIOy75eE3yiazgruQ9w7OcbIFjl4rOscD+ZoLMQ9BjOmRuhws82yz3cE+i2cd2FQeyabYlQuwUJQSkT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 06:33:14AM -0700, Kees Cook wrote:
> ret = min(ret, (int)(PAGE_SIZE - 1 - off));
> if (!ret)
> 	break;

One question about the truncation behavior here: when an element does
not fully fit in the remaining buffer, this min() can cause only part
of that element to be copied. For example, if the remaining space is
4 bytes and the next element produces "123456789\n", the resulting
output could contain only "1234".

This leaves the reader with no way to distinguish a genuinely short
value from one that was truncated due to the PAGE_SIZE limit, while
the array otherwise still looks like a normal comma-separated list.

Is this partial-element truncation intentional for this patch, or is
the expectation that it gets handled as part of the later seq_buf
conversion? Would it be preferable to avoid copying an element unless
it fits completely, and leave the larger-buffer case to be addressed
later in the series?

