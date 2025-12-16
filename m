Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF97D5E15A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E506B0005; Tue, 16 Dec 2025 09:03:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEBC36B0089; Tue, 16 Dec 2025 09:03:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7226B008A; Tue, 16 Dec 2025 09:03:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE9BA6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:03:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67849160651
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:03:29 +0000 (UTC)
X-FDA: 84225501738.20.B891E35
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8821C1C002A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:03:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bnjcpn99;
	spf=pass (imf20.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765893807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESdp0QKInqUOJAUdSgLqUxfxTAswaee7nnyHp/EI2kM=;
	b=ZkEI9RvZbBfP+pnq7hCsYR+AcDLUs81YVwmDyTMzMmzXPzERFkBcbINywkl7g8lkcC6IaA
	T9cWwmGbov3/j9DYHbL0P0I6wZ6bBQqhPSpTkBD5Ooj1foXFQjE1ThxnWLzoRCoIPxvtJl
	Tnf5L6JYO0u1t/ZKsivVyPHf93BNknU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765893807; a=rsa-sha256;
	cv=none;
	b=cyuBexJJZ6jY54BKGQtCoFTVSOwpVoZE7bCg1Rxo3ZuayExgt5qpjjOawtdvxzwAW2nJ3K
	xFi5fIDcKnKoW6QRRtaiRkJz/liY1c5MVf0yhAmmftrQBiLR5KHW7lbFPOmMzygMTkumIW
	9jChePPVKGXZCgTmWXCGshX3oqlTe1w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bnjcpn99;
	spf=pass (imf20.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [40.68.199.203])
	by linux.microsoft.com (Postfix) with ESMTPSA id 90FE0200D625;
	Tue, 16 Dec 2025 06:03:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 90FE0200D625
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1765893806;
	bh=ESdp0QKInqUOJAUdSgLqUxfxTAswaee7nnyHp/EI2kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnjcpn99CN0FZBzx2pfhnThcNjtJfMvn23jLeWoEwgbE5AeJ4btjN7u7gQSieacEU
	 oO2t+9RyYwa3jkG+CSVwJoZrDmP+l+OroRB42+zF3CL54AzJlQWbWsMCLIZbvbfl11
	 L0q/w7bkWgpIPtxqOFSOOTBbEVYkesmF/1YHLf/k=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm: vmscan: add PID and cgroup ID to vmscan tracepoints
Date: Tue, 16 Dec 2025 06:02:50 -0800
Message-Id: <20251216140252.11864-1-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251208181413.4722-1-tballasi@linux.microsoft.com>
References: <20251208181413.4722-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a5ku3imfw4ezm5yszindwb8zxu6kth8q
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8821C1C002A
X-Rspam-User: 
X-HE-Tag: 1765893807-636099
X-HE-Meta: U2FsdGVkX1+3jYDRBQzl686K3mxqlHgKGX66DCZOa+Fnvi5jgX+Bho8CGfSJeht6P867ojiKfPs9OtSBO8dl4Cmg69MLoHxk6B/IVujKxPO+yCFbR8SHHOk4dCeme2Vq8Bbg3VNoOeLYFyQ5h83fyR6TDDMwGjCXYKrLf5iK7rUSbc3gn1lssJ8XJG2vDrEU7/1UJqaOrdv3icr39LhNDmQIFhzZllZr8ATg++j4SnAYkdh43xZwt8Br+5nQz4a/HJlLOIpYOK5uN7XvTLC9lWEMqz5t+jbRB9AxVZlkQ03sVRzjAANAgdUcCz6DNaxe3sPSiO+FAPp6cudwxjioEFFfZBWCtN0j5efzMs6HJb0vHFG2U+6Wtote9B8rDor5nJ1RPGD/2kopWoUKprMTtszZXQNI0nGDiHsi52Se+vUiiJ7E0AXNae2PD5t5Zcooo35S9kevlf0xHl86nR8C4+MFBObr6W1/mDL9cNKgXJ5CoDajKWDD6HgdpkKBOWPw2w3SBE+g5BUieVzyfifC4+K2If+FnWrZH2eP+4gYm2IG+oegv2VbaEILwLS3UOfY+8DhaIYf8C56BJkRtgd4v9FK2sRqsT90gRwXhm4XRP6pm59ggTw3wbGhrKTM9qZqkwrKdl8roXthsgGinOmo4+OE7xmNzBPcZ3X274EK8/V7jDByZJ/e/kPlfMU6jXcqmgt9S1Pnu8kYNXv9K9PjEqi17jebLRBK+sWyBfp/OIKBZDpVevDDiuzElFLt6JFdcdwSFL/rJUTJKoE3np0FIfhPDUhIv1otS8HM/adbG+kqRxJsS/hRzBhOxRG0k2z30WPQ8uiye0H0RWuvYBQpxtiOhYqEe/PoaL6NZXMjwaq0aiy89TcHzO5QoDENteNwVc8FeDzW/JUvX50WWSVfFwyppssWlFZZVQyMep+LdGqob0CCFfmKs88Kkzgd+BMLwYZFeRFNcnrubsS8OOk
 5IY/RE3r
 NNjthYtAV3V0lNauAg1BtPRMaFGxld/0cC5660stlFJVrfTT/g2m8ZfMv5/Y7t95CBzZLLNsOnXDuVS9sDV75UBW483XBSZYO6Oqgh8irHNZUoaCdNxtJXbRIRYltWszciS2sW3cpPDiXHBL75s2+0BQEpIY3Kq+7gFv+pOcuXQf4CSpF/4SSjgmk6jKj1uc8AQtzlq2/ttnrucMkohXmC5CehNr7Iyxy1/pHPd3HLe2UDiY8Npr27+SBd9JE2zX4q4T+hhFnUJBwsGctCrB9882PiF1Y8703DqwyhsYxms+tTeA4rp2bTadb1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v2:
- Swapped field entries to prevent a hole in the ring buffer

Link to v1:
https://lore.kernel.org/linux-trace-kernel/20251208181413.4722-1-tballasi@linux.microsoft.com/

Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Thomas Ballasi (2):
  mm: vmscan: add cgroup IDs to vmscan tracepoints
  mm: vmscan: add PIDs to vmscan tracepoints

 include/trace/events/vmscan.h | 77 +++++++++++++++++++++++------------
 mm/vmscan.c                   | 17 ++++----
 2 files changed, 60 insertions(+), 34 deletions(-)

-- 
2.33.8


